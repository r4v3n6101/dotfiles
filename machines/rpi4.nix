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
        sopsFile = "${inputs.secrets}/rpi4/wireless.conf";
      };
    };
  };

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
    initrd.allowMissingModules = true;
    extraModulePackages = [ config.boot.kernelPackages.rtw88 ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
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
  };

  environment.systemPackages = with pkgs; [ ];

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05";
}
