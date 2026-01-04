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

      "awg_srv.conf" = {
        format = "binary";
        sopsFile = "${inputs.secrets}/pvxsrv/awg_srv.conf";
      };
      "awg_peers.conf" = {
        format = "binary";
        sopsFile = "${inputs.secrets}/pvxsrv/awg_peers.conf";
      };
    };
    templates = {
      "awg.conf".content = ''
        ${config.sops.placeholder."awg_srv.conf"}

        PostUp = ${pkgs.iptables}/bin/iptables -A INPUT -p udp --dport 5496 -m conntrack --ctstate NEW -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/iptables -A FORWARD -i eth0 -o awg0 -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/iptables -A FORWARD -i awg0 -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/ip6tables -A FORWARD -i awg0 -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE --wait 10 --wait-interval 50
        PostDown = ${pkgs.iptables}/bin/iptables -D INPUT -p udp --dport 5496 -m conntrack --ctstate NEW -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/iptables -D FORWARD -i eth0 -o awg0 -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/iptables -D FORWARD -i awg0 -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/ip6tables -D FORWARD -i awg0 -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE --wait 10 --wait-interval 50

        ${config.sops.placeholder."awg_peers.conf"}
      '';
    };
  };

  documentation.enable = false;

  nix = {
    channel.enable = false;
    optimise.automatic = true;
    gc.automatic = true;
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
    kernelModules = [ "amneziawg" ];
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
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
    hostName = "pvxsrv";
    firewall = {
      allowedTCPPorts = [
        20000
        5496
      ];
      allowedUDPPorts = [ 5496 ];
    };
    wg-quick.interfaces.wg0 = {
      autostart = true;
      type = "amneziawg";
      configFile = config.sops.templates."awg.conf".path;
    };
  };

  environment.systemPackages = with pkgs; [
    amneziawg-tools
    neovim
    kitty
  ];

  services = {
    cloud-init = {
      enable = true;
      network.enable = true;
      ext4.enable = true;
    };
    openssh = {
      enable = true;
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
  };

  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05";
}
