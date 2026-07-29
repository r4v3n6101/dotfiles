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
        pkgs,
        ...
      }:
      {
        imports = [
          "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          inputs.home-manager.nixosModules.home-manager
        ];

        nixpkgs.config.allowUnfree = true;

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

        boot = {
          loader = {
            grub.enable = false;
            generic-extlinux-compatible.enable = true;
          };
          initrd = {
            allowMissingModules = true;
            availableKernelModules = lib.mkForce [
              "xhci_hcd"
              "scsi_mod"
              "sd_mod"
              "uas"
              "usb_storage"
            ];
          };
          kernelParams = [ "usb-storage.quirks=7825:a2a4:u" ];
          kernel.sysctl = {
            "net.ipv4.ip_forward" = 1;
            "net.ipv6.conf.all.forwarding" = 1;
            "net.core.default_qdisc" = "fq";
            "net.ipv4.tcp_congestion_control" = "bbr";
          };
          zfs.forceImportRoot = false;
        };

        sdImage = {
          compressImage = false;
          firmwareSize = 512;
        };

        hardware = {
          enableRedistributableFirmware = true;
          raspberry-pi = {
            "4".fkms-3d.enable = true;

            firmware.uboot.enable = true;
            configtxt.settings.all = {
              enable_uart = 1;
              uart_2ndstage = 1;
              boot_delay = 1;
              hdmi_safe = 1;
              hdmi_force_hotplug = 1;
            };
          };
        };

        security.sudo = {
          enable = true;
          wheelNeedsPassword = false;
        };

        users.users.${user} = {
          isNormalUser = true;
          description = user;
          initialPassword = "toor";
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
          openssh.authorizedKeys.keyFiles = [
            ../keys/id_r4mac.pub
            ../keys/id_termius.pub
          ];
        };

        environment = {
          systemPackages = with pkgs; [
            git
            networkmanagerapplet
            usbutils
          ];
          gnome.excludePackages = with pkgs; [
            gnome-tour
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

        services = {
          xserver.enable = true;
          displayManager.gdm.enable = true;
          desktopManager.gnome.enable = true;
        };

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit inputs;
          };
          backupFileExtension = "build";
          users.${user}.imports = [
            { home.stateVersion = "26.11"; }

            self.homeModules.tools
            self.homeModules.kitty
            self.homeModules.nixvim
          ];
        };

        time.timeZone = "Europe/Moscow";
        i18n.defaultLocale = "en_US.UTF-8";

        system.stateVersion = "26.11";
      };
  };
}
