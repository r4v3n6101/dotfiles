{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
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
        sopsFile = "${inputs.secrets}/pvxsrv/yggdrasil.key";
      };

      "mtproto.env" = {
        format = "dotenv";
        sopsFile = "${inputs.secrets}/pvxsrv/mtproto.env";
      };

      "sing-box.json" = {
        key = "";
        format = "json";
        sopsFile = "${inputs.secrets}/pvxsrv/sing-box.json";
      };
    };
  };

  documentation.enable = false;
  nix = {
    channel.enable = false;
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    settings = {
      trusted-users = [
        "@wheel"
        "root"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        bios = {
          type = "EF02";
          size = "1M";
          priority = 1;
        };
        boot = {
          label = "BOOT";
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };

  boot = {
    loader.grub = {
      enable = true;
      efiSupport = false;
    };
    initrd = {
      verbose = true;
      availableKernelModules = [
        "virtio"
        "virtio_pci"
        "virtio_blk"
        "virtio_scsi"
      ];
    };
    kernelParams = [ "console=ttyS0" ];
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    hashedPassword = "!";
    openssh.authorizedKeys.keyFiles = [
      ../keys/id_r4mac.pub
      ../keys/id_termius.pub
    ];
  };

  environment.systemPackages = [ ];

  networking = {
    hostName = "pvxsrv";
    firewall = {
      allowedTCPPorts = [
        443
        8000
      ];
    };
  };

  services = {
    cloud-init = {
      enable = true;
      network.enable = true;
      ext4.enable = true;
    };
    openssh = {
      enable = true;
      openFirewall = true;
      ports = [ 20000 ];
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
    };

    yggdrasil = {
      enable = true;
      group = "wheel";
      openMulticastPort = false;
      settings = {
        PrivateKeyPath = config.sops.secrets."yggdrasil.key".path;
        Peers = [
          "quic://[2a12:5940:b1a0::2]:65535"
          "tls://n.ygg.yt:443"
        ];
      };
    };
    yggdrasil-jumper.enable = true;

    sing-box = {
      enable = true;
      settings = {
        _secret = config.sops.secrets."sing-box.json".path;
        quote = false;
      };
    };
  };

  virtualisation = {
    docker.enable = true;

    oci-containers = {
      backend = "docker";
      containers.mtproto-proxy = {
        image = "telegrammessenger/proxy:latest";
        autoStart = true;
        ports = [
          "[::]:8000:443"
          "0.0.0.0:8000:443"
        ];
        environmentFiles = [
          config.sops.secrets."mtproto.env".path
        ];
        volumes = [
          "mtproto-proxy-data:/data"
        ];
      };
    };
  };

  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05";
}
