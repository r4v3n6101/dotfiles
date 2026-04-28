{
  inputs,
  self,
  ...
}:
{
  flake = {
    nixosConfigurations.pvxsrv = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.nixosModules.radicle-seed-node
        self.nixosModules.pvxsrv
      ];
    };

    nixosModules = {
      pvxsrv =
        { config, pkgs, ... }:
        {
          imports = [
            inputs.disko.nixosModules.disko
            inputs.sops-nix.nixosModules.sops
            ../yank/telemt.nix
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

              "sing-box.json" = {
                key = "";
                format = "json";
                sopsFile = "${inputs.secrets}/pvxsrv/sing-box.json";
              };

              "telemt.conf" = {
                format = "binary";
                sopsFile = "${inputs.secrets}/pvxsrv/telemt.conf";
              };

              "radicle.key" = {
                format = "binary";
                sopsFile = "${inputs.secrets}/pvxsrv/radicle.key";
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

          networking = {
            hostName = "pvxsrv";
            domain = "pivozavr.store";
            firewall = {
              allowedTCPPorts = [
                80
                443
              ];
              allowedUDPPorts = [
                443
              ];
            };
          };

          security.sudo = {
            enable = true;
            wheelNeedsPassword = false;
          };

          users.users = {
            admin = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              hashedPassword = "!";
              openssh.authorizedKeys.keyFiles = [
                ../keys/id_r4mac.pub
                ../keys/id_termius.pub
              ];
            };
            sing-box.extraGroups = [ "caddy" ];
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

            telemt = {
              enable = true;
              configFile = config.sops.secrets."telemt.conf".path;
            };

            radicle = {
              privateKey = config.sops.secrets."radicle.key".path;
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMI6h1iQfRsUnB9fc2ciY+d0adLer9LRNAsWAkg28lV radicle";
            };

            caddy = {
              enable = true;

              virtualHosts."${config.networking.domain}:4432".extraConfig = ''
                reverse_proxy https://itunes.apple.com {
                  header_up Host {upstream_hostport}
                }
              '';
            };
          };

          time.timeZone = "Europe/Stockholm";

          system.stateVersion = "25.05";
        };

      radicle-seed-node =
        { config, pkgs, ... }:
        let
          web-app = pkgs.radicle-explorer.withConfig {
            preferredSeeds = [
              {
                hostname = "radicle.${config.networking.domain}";
                port = 443;
                scheme = "https";
              }
            ];
          };
        in
        {
          networking.firewall.allowedTCPPorts = [ 80 ];

          services = {
            radicle = {
              enable = true;
              node.openFirewall = true;
              httpd.enable = true;

              settings = {
                node = {
                  alias = config.networking.domain;
                  seedingPolicy = {
                    default = "block";
                    scope = "follow";
                  };
                };
                web.pinned.repositories = [
                  "rad:zrmnLbcmCRiaVbpAG3VRZ3b8Pkwi" # dotfiles
                  "rad:z36T62dkJSM7RCKd3ivFb4MjQwDST" # rairplay
                  "rad:z486CxugaTS67yovoZUdgtvH8stRr" # playastation
                ];
              };
            };

            caddy = {
              enable = true;

              # This port ruines general config
              virtualHosts."radicle.${config.networking.domain}:4432".extraConfig = ''
                root * ${web-app}

                handle /api/* {
                  reverse_proxy 127.0.0.1:8080
                }

                handle /raw/* {
                  reverse_proxy 127.0.0.1:8080
                }

                handle /rad:* {
                  reverse_proxy 127.0.0.1:8080
                }

                handle {
                  try_files {path} {path}/ /index.html
                  file_server
                }
              '';
            };
          };
        };
    };
  };
}
