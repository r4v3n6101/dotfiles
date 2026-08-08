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
        self.nixosModules.radicle-pinned-repos
        self.nixosModules.privex-hardware
        self.nixosModules.pvxsrv
      ];
    };

    nixosModules = {
      privex-hardware =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          imports = [
            inputs.disko.nixosModules.disko
          ];

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

          disko.devices.disk.main = {
            type = "disk";
            device = "/dev/sda";

            content = {
              type = "gpt";

              partitions = {
                bios = {
                  size = "1M";
                  type = "EF02";
                };

                boot = {
                  size = "1G";

                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/boot";
                  };
                };

                swap = {
                  size = "2G";

                  content = {
                    type = "swap";
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

          services.cloud-init = {
            enable = true;
            network.enable = true;
            ext4.enable = true;
          };
        };

      pvxsrv =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          imports = [
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
                  "tcp://vpn.itrus.su:7991"
                  "tls://cirno.nadeko.net:44442"
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
              openFirewall = false;
              httpsPort = 4432;
              virtualHosts."${config.networking.domain}".extraConfig = ''
                reverse_proxy https://itunes.apple.com {
                  header_up Host {upstream_hostport}
                }
              '';
            };
          };

          systemd = {
            paths.restart-sing-box-on-caddy-cert-change = {
              wantedBy = [ "multi-user.target" ];
              pathConfig = {
                PathChanged = [
                  "/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/${config.networking.domain}/${config.networking.domain}.crt"
                  "/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/${config.networking.domain}/${config.networking.domain}.key"
                ];
                Unit = "restart-sing-box-on-caddy-cert-change.service";
              };
            };

            services.restart-sing-box-on-caddy-cert-change = {
              serviceConfig = {
                Type = "oneshot";
                ExecStart = "${pkgs.systemd}/bin/systemctl restart sing-box.service";
              };
            };
          };

          time.timeZone = "Europe/Stockholm";

          system.stateVersion = "25.05";
        };
    };
  };
}
