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
    secrets.private_key = {
      sopsFile = "${inputs.secrets}/secrets/amneziawg.yaml";
    };
  };

  nix = {
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

      postUp = "${pkgs.iptables}/bin/iptables -A INPUT -p udp --dport 5496 -m conntrack --ctstate NEW -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/iptables -A FORWARD -i eth0 -o awg0 -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/iptables -A FORWARD -i awg0 -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/ip6tables -A FORWARD -i awg0 -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE --wait 10 --wait-interval 50";
      postDown = "${pkgs.iptables}/bin/iptables -D INPUT -p udp --dport 5496 -m conntrack --ctstate NEW -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/iptables -D FORWARD -i eth0 -o awg0 -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/iptables -D FORWARD -i awg0 -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/ip6tables -D FORWARD -i awg0 -j ACCEPT --wait 10 --wait-interval 50; ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE --wait 10 --wait-interval 50";

      address = [ "10.0.0.1/16" ];
      listenPort = 5496;
      privateKeyFile = config.sops.secrets.private_key.path;
      peers = [
        {
          allowedIPs = [ "10.0.10.1/24" ];
          publicKey = "aGh3+HryK0fVP4WArTh29gkZyle0PGwEee6sI4n3F3U=";
        }
        {
          allowedIPs = [ "10.0.20.1/24" ];
          publicKey = "/CZKP4MXtaQdfamSmPRoCgIRdgJhuod3pXNkzzeBtm0=";
        }
        {
          allowedIPs = [ "10.0.30.1/24" ];
          publicKey = "AVLsKVp9KufYEYTcroAYzcWtzTEaBCVU1PPMRoYAogQ=";
        }
      ];
      extraOptions = {
        Jc = 57;
        Jmin = 302;
        Jmax = 1001;
        S1 = 34;
        S2 = 89;
        H1 = 594713031;
        H2 = 1868774696;
        H3 = 1475907813;
        H4 = 537583515;
      };
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
  };

  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05";
}
