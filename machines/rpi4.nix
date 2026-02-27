{
  config,
  lib,
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
      "yggdrasil.key" = {
        format = "binary";
        sopsFile = "${inputs.secrets}/rpi4/yggdrasil.key";
      };
      "gost.env" = {
        format = "dotenv";
        sopsFile = "${inputs.secrets}/rpi4/gost.env";
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
        "uas"
        "usb_storage"
      ];
    };
    kernelParams = [ "usb-storage.quirks=7825:a2a4:u" ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    raspberry-pi."4" = {
      fkms-3d.enable = true;
      gpio = {
        enable = true;
      };
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "!";
    openssh.authorizedKeys.keyFiles = [
      ../keys/id_r4mac.pub
      ../keys/id_termius.pub
    ];
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    usbutils
    libgpiod
  ];

  networking = {
    hostName = "rpi4";
    useDHCP = true;
    firewall.allowedTCPPorts = [
      3456
      5000
    ];
  };

  services = {
    openssh = {
      enable = true;
      openFirewall = true;
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
    yggdrasil-jumper.enable = true;
  };

  systemd.services.forward-traffic = {
    description = "Forward traffic to the final node";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.gost} $ROUTE1 $ROUTE2";
      EnvironmentFile = config.sops.secrets."gost.env".path;
      Restart = "always";
      RestartSec = 5;
    };
  };

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05";
}
