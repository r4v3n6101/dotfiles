{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      "wireless.conf" = {
        format = "binary";
        owner = "wpa_supplicant";
        sopsFile = "${inputs.secrets}/rpi4/wireless.conf";
      };
      "yggdrasil.key" = {
        format = "binary";
        sopsFile = "${inputs.secrets}/rpi4/yggdrasil.key";
      };
    };
  };

  documentation.enable = false;

  nix = {
    channel.enable = false;
    optimise.automatic = true;
    gc.automatic = true;
    settings = {
      trusted-users = [ "@wheel" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  boot = {
    initrd = {
      allowMissingModules = true;
      availableKernelModules = [
        "xhci_hcd"
        "scsi_mod"
        "sd_mod"
        "usb_storage"
      ];
    };
    blacklistedKernelModules = [ "uas" ];
    extraModulePackages = [ config.boot.kernelPackages.rtw88 ];
  };

  hardware.raspberry-pi."4".gpio = {
    enable = true;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "gpio"
    ];
    hashedPassword = "!";
    openssh.authorizedKeys.keyFiles = [
      ../keys/id_r4mac.pub
      ../keys/id_termius.pub
    ];
  };

  networking = {
    hostName = "rpi4";
    useDHCP = true;
    wireless = {
      enable = true;
      allowAuxiliaryImperativeNetworks = true;
      secretsFile = config.sops.secrets."wireless.conf".path;
      networks = {
        home = {
          ssid = "🤓";
          pskRaw = "ext:psk_home";
        };
      };
    };
  };

  services = {
    openssh = {
      enable = true;
      ports = [ 20202 ];
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
    };
    yggdrasil = {
      enable = true;
      group = "wheel";
      openMulticastPort = true;
      settings = {
        PrivateKeyPath = config.sops.secrets."yggdrasil.key".path;
        Peers = [
          "tcp://ip4.01.msk.ru.dioni.su:9002"
          "tcp://yggdrasil.1337.moe:7676"
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    usbutils
    libgpiod
  ];

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05";
}
