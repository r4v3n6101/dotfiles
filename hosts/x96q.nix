{
  config,
  inputs,
  self,
  ...
}:
let
  inherit (config.flake.modules) nixos;
  user = "r4v3n6101";
in
{
  flake = {
    nixosConfigurations.x96q = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";

      modules = [
        nixos.x96q
      ];
    };

    modules.nixos.x96q =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) linux-armbian-sunxi64 uboot-x96q;
      in
      {
        imports = [
          "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
        ];

        nix.settings = {
          trusted-users = [
            "@wheel"
            "root"
          ];

          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };

        image.baseName = "nixos-x96q";
        sdImage = {
          compressImage = false;
          rootVolumeLabel = "NIXOS_X96Q";

          populateFirmwareCommands = "";

          populateRootCommands = ''
            ${config.boot.loader.generic-extlinux-compatible.populateCmd} \
              -c ${config.system.build.toplevel} -d ./files/boot
          '';

          postBuildCommands = ''
            dd if=${uboot-x96q} of="$img" bs=1024 seek=8 conv=notrunc status=none
          '';
        };

        boot = {
          kernelPackages = pkgs.linuxPackagesFor linux-armbian-sunxi64;
          kernelModules = [ "g_serial" ];

          kernelParams = [
            "earlycon"
            "console=ttyS0,115200n8"
            "rootwait"
            "cpufreq.off=1"
          ];

          initrd = {
            includeDefaultModules = false;
            systemd.tpm2.enable = false;
          };

          loader = {
            grub.enable = false;
            generic-extlinux-compatible.enable = true;
          };
        };

        systemd.targets.getty.wants = [ "serial-getty@ttyGS0.service" ];

        hardware = {
          enableAllHardware = lib.mkForce false;

          deviceTree = {
            enable = true;
            name = "allwinner/sun50i-h313-x96q-lpddr3.dtb";
            overlays = [
              {
                name = "usb-console";
                dtsText = ''
                  /dts-v1/;
                  /plugin/;
                  / { compatible = "hechuang,x96-q"; };
                  &usbotg { status = "okay"; dr_mode = "peripheral"; };
                  &ehci0 { status = "disabled"; };
                  &ohci0 { status = "disabled"; };
                  &mmc1 { status = "disabled"; };
                '';
              }
            ];
          };
        };

        fileSystems."/" = {
          device = "/dev/disk/by-label/NIXOS_X96Q";
          fsType = "ext4";
          options = [ "noatime" ];
        };

        security.sudo = {
          enable = true;
          wheelNeedsPassword = false;
        };

        users.users.${user} = {
          isNormalUser = true;
          initialPassword = "toor";
          openssh.authorizedKeys.keyFiles = [
            ../keys/id_r4mac.pub
            ../keys/id_rskey.pub
            ../keys/id_termius.pub
          ];
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
        };

        networking = {
          hostName = "x96q";
          networkmanager.enable = true;
          nftables.enable = true;
        };

        services.openssh = {
          enable = true;

          settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "no";
          };
        };

        time.timeZone = "Europe/Moscow";
        i18n.defaultLocale = "en_US.UTF-8";

        system.stateVersion = "26.11";
      };
  };
}
