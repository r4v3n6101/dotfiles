{
  inputs,
  self,
  ...
}:
let
  user = "r4v3n6101";
in
{
  flake = {
    nixosConfigurations.rpi4 = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        self.nixosModules.rpi4
      ];
    };

    nixosModules.rpi4 =
      {
        lib,
        ...
      }:
      {
        imports = [
          "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          inputs.home-manager.nixosModules.home-manager
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

        fileSystems = {
          "/" = {
            device = "/dev/disk/by-label/NIXOS_SD";
            fsType = "ext4";
            options = [ "noatime" ];
          };
        };

        boot.kernelParams = lib.mkForce [
          "loglevel=8"
          "console=ttyAMA0,115200n8"
          "usb-storage.quirks=7825:a2a4:u"
        ];

        sdImage = {
          compressImage = false;
        };

        hardware = {
          enableAllHardware = lib.mkForce false;
          raspberry-pi = {
            firmware.uboot.enable = true;
            configtxt = {
              settings = {
                all.enable_uart = true;
                all.core_freq = 250;
              };
              deviceTreeOverlays.pi4 = [
                {
                  miniuart-bt = { };
                }
              ];
            };
          };
        };

        security.sudo = {
          enable = true;
          wheelNeedsPassword = false;
        };

        users.users.${user} = {
          isNormalUser = true;
          initialPassword = "toor";
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
        };

        networking = {
          hostName = "rpi4";
          wireless.enable = false;
          networkmanager = {
            enable = true;
            wifi.backend = "iwd";
            ensureProfiles.profiles.zamai86 = {
              connection = {
                id = "zamai86";
                type = "wifi";
                interface-name = "wlan0";
              };
              wifi = {
                mode = "infrastructure";
                ssid = "zamai86";
              };
              wifi-security = {
                key-mgmt = "wpa-psk";
                psk = "ruwdop-4kymga-jIdpif";
              };
              ipv4.method = "auto";
              ipv6.method = "auto";
            };
          };
        };

        services.openssh.enable = true;

        # home-manager = {
        #   useGlobalPkgs = true;
        #   useUserPackages = true;
        #   extraSpecialArgs = {
        #     inherit inputs;
        #   };
        #   backupFileExtension = "build";
        #   users.${user}.imports = [
        #     { home.stateVersion = "26.11"; }
        #
        #     self.homeModules.tools
        #     self.homeModules.nixvim
        #   ];
        # };

        time.timeZone = "Europe/Moscow";
        i18n.defaultLocale = "en_US.UTF-8";

        system.stateVersion = "26.11";
      };
  };
}
