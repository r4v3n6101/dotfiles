{ inputs, self, ... }:
{
  flake.darwinModules.microvm-builder =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.microvm-builder;
    in
    {
      options.microvm-builder = {
        sshPort = lib.mkOption {
          type = lib.types.port;
          default = 2222;
          description = "SSH port for builder";
        };

        sshKey = lib.mkOption {
          type = lib.types.path;
          default = "/Users/${config.system.primaryUser}/.ssh/microvm-builder";
          description = "Path to SSH private key for builder";
        };

        maxJobs = lib.mkOption {
          type = lib.types.int;
          default = 8;
          description = "Maximum number of parallel jobs on the builder";
        };

        speedFactor = lib.mkOption {
          type = lib.types.int;
          default = 1;
          description = "Speed factor for the builder (higher = preferred)";
        };

        cpu = lib.mkOption {
          type = lib.types.int;
          default = 8;
          description = "Number of CPUs for builder";
        };

        memory = lib.mkOption {
          type = lib.types.int;
          default = 8192;
          description = "Memory in MiB for builder";
        };

        diskSize = lib.mkOption {
          type = lib.types.int;
          default = 50 * 1024;
          description = "Disk size in MiB for builder";
        };
      };

      config = {
        nix = {
          buildMachines = [
            {
              hostName = "microvm-builder";
              protocol = "ssh-ng";
              systems = [
                "aarch64-linux"
                "x86_64-linux"
              ];
              supportedFeatures = [
                "benchmark"
                "kvm"
                "nixos-test"
                "big-parallel"
              ];
              maxJobs = cfg.maxJobs;
            }
          ];
          distributedBuilds = lib.mkForce true;
          settings.builders-use-substitutes = lib.mkDefault true;
        };

        environment = {
          etc."ssh/ssh_config.d/100-microvm-builder.conf".text = ''
            Host microvm-builder
              HostName localhost
              Port ${toString cfg.sshPort}
              User root
              IdentityFile ${cfg.sshKey}
              StrictHostKeyChecking no
              UserKnownHostsFile /dev/null
          '';

          systemPackages =
            let
              vfkit-sock = "/tmp/vfkit.sock";
              overlay-img = "/tmp/microvm-builder-overlay.img";

              microvm-module = {
                imports = [
                  inputs.microvm.nixosModules.microvm
                ];

                microvm = {
                  optimize.enable = true;

                  vcpu = cfg.cpu;
                  mem = cfg.memory;

                  hypervisor = "vfkit";
                  vmHostPackages = inputs.nixpkgs.legacyPackages.aarch64-darwin;
                  vfkit = {
                    rosetta = {
                      enable = true;
                      install = true;
                    };
                    extraArgs = [
                      "--device"
                      "virtio-net,unixSocketPath=${vfkit-sock},mac=5a:94:ef:e4:0c:ee"
                    ];
                  };

                  storeDiskType = "squashfs";
                  writableStoreOverlay = "/nix/.rw-store";
                  volumes = [
                    {
                      image = overlay-img;
                      mountPoint = "/";
                      size = cfg.diskSize;
                    }
                  ];
                };
              };

              microvm-nixos = self.nixosConfigurations.linux-builder.extendModules {
                modules = [ microvm-module ];
              };

              microvm-bin = pkgs.writeShellScriptBin "microvm-builder-start" ''
                rm -f ${vfkit-sock}

                ${lib.getExe pkgs.gvproxy} \
                  --ssh-port ${toString cfg.sshPort} \
                  --listen-vfkit "unixgram://${vfkit-sock}" &

                until [ -S ${vfkit-sock} ]; do sleep 1; done;

                ${lib.getExe microvm-nixos.config.microvm.declaredRunner}
              '';
            in
            [
              microvm-bin
            ];
        };
      };
    };
}
