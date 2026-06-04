{ inputs, self, ... }:
{
  flake = {
    nixosConfigurations.linux-graphics = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        self.nixosModules.linux-graphics
      ];
    };

    nixosModules.linux-graphics =
      { ... }:
      {
        imports = [
          inputs.microvm.nixosModules.microvm
        ];

        microvm = {
          optimize.enable = true;
          hypervisor = "vfkit";
          vmHostPackages = inputs.nixpkgs.legacyPackages.aarch64-darwin;

          vcpu = 4;
          mem = 4096;
          graphics.enable = true;

          storeDiskType = "squashfs";
          writableStoreOverlay = "/nix/.rw-store";
          volumes = [
            {
              image = "vmfs.img";
              mountPoint = "/";
              size = 50 * 1024;
            }
          ];

          interfaces = [
            {
              type = "user";
              id = "usernet";
              mac = "02:00:00:01:01:01";
            }
          ];
        };

        nix = {
          channel.enable = false;
          registry.nixpkgs.flake = inputs.nixpkgs;
          settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
        };

        users.users.admin = {
          isNormalUser = true;
          initialPassword = "toor";
        };

        services = {
          xserver.enable = true;
          desktopManager.gnome.enable = true;
          displayManager.gdm.enable = true;
        };

        programs.xwayland.enable = true;
      };
  };
}
