{
  config,
  inputs,
  ...
}:
let
  inherit (config.flake.modules) nixos;
in
{
  flake = {
    nixosConfigurations.pvxsrv = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos.radicle-seed-node
        nixos.privex-hardware
        nixos.pvxsrv
      ];
    };

    modules.nixos = {
      privex-hardware = {
        imports = [
          inputs.disko.nixosModules.disko
        ];

        boot = {
          loader.grub = {
            enable = true;
            efiSupport = false;
          };
          initrd.availableKernelModules = [
            "virtio"
            "virtio_pci"
            "virtio_blk"
            "virtio_scsi"
          ];

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
          ...
        }:
        {
          imports = [
            inputs.agenix.nixosModules.default
            inputs.agenix-rekey.nixosModules.default
            ../yank/telemt.nix
          ];

          nixpkgs = {
            config.permittedInsecurePackages = [
              "radicle-node-1.10.3"
            ];
            overlays = [
              (_: prev: {
                radicle-node = prev.radicle-node.overrideAttrs {
                  doCheck = false;
                };
              })
            ];
          };

          age = {
            rekey = rec {
              storageMode = "derivation";
              agePlugins = [
                inputs.age-plugin-gpg.packages.aarch64-darwin.default
                inputs.age-plugin-gpg.packages.aarch64-linux.default
                inputs.age-plugin-gpg.packages.x86_64-linux.default
              ];

              masterIdentities = [ ];
              hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElQRo7iSxrQ/rnEuLQh/srSVzhcS6ziZGcschAjlATC";
              extraEncryptionPubkeys = [
                "age1gpg129dtszlf0fkewgzxd9d6qe680rvu5ttl9cdads"
                hostPubkey
              ];
            };

            secrets = {
              "wg.key" = {
                file = "${inputs.secrets}/pvxsrv/wg.key.age";
                owner = "root";
                mode = "0400";
              };
              "yggdrasil.key".file = "${inputs.secrets}/pvxsrv/yggdrasil.key.age";
              "sing-box.json".file = "${inputs.secrets}/pvxsrv/sing-box.json.age";
              "telemt.conf".file = "${inputs.secrets}/pvxsrv/telemt.conf.age";
              "radicle.key".file = "${inputs.secrets}/pvxsrv/radicle.key.age";
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

          security.sudo = {
            enable = true;
            wheelNeedsPassword = false;
          };

          users.users = {
            admin = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              # toor
              hashedPassword = "$6$wtkmlmnTodWBnkbB$Sf2/xKlSw1lLThihRDIsViHw/BHmEaRcfp6AYmCo4ffaYwh4a4sOIYPMSNu8J2s2cAuVQL3W8FawIxNbW/YSU0";
              openssh.authorizedKeys.keyFiles = [
                ../keys/id_r4mac.pub
                ../keys/id_rskey.pub
                ../keys/id_termius.pub
              ];
            };
            sing-box.extraGroups = [ "caddy" ];
          };

          networking = {
            hostName = "pvxsrv";
            domain = "pivozavr.store";
            firewall = {
              interfaces.tun0.allowedUDPPorts = [ 51820 ];
              allowedTCPPorts = [
                80
                443
              ];
              allowedUDPPorts = [
                443
              ];
            };

            nat = {
              enable = true;
              externalInterface = "eth0";
              internalInterfaces = [ "wg0" ];
            };

            wireguard.interfaces.wg0 = {
              ips = [ "10.0.0.1/32" ];
              listenPort = 51820;
              mtu = 1200;

              privateKeyFile = config.age.secrets."wg.key".path;
              peers = [
                {
                  publicKey = "9a4HgmdPX8supsgLSxJbOahaczIBynXJ76mHqMj5VlQ=";
                  allowedIPs = [ "10.0.0.2/32" ];
                }
              ];
            };
          };

          services = {
            openssh = {
              enable = true;
              openFirewall = true;
              ports = [ 20000 ];
              settings = {
                PasswordAuthentication = false;
                KbdInteractiveAuthentication = false;
                PermitRootLogin = "no";
              };
            };

            yggdrasil = {
              enable = true;
              group = "wheel";
              openMulticastPort = false;
              settings = {
                PrivateKeyPath = config.age.secrets."yggdrasil.key".path;
                Peers = [
                  "tcp://vpn.itrus.su:7991"
                  "tls://cirno.nadeko.net:44442"
                ];
              };
            };
            yggdrasil-jumper = {
              enable = true;
              logLevel = "info";

              settings = {
                listen_port = 4701;
                yggdrasil_admin_reconnect = true;
                wireguard = false;
              };
            };

            sing-box = {
              enable = true;
              settings = {
                _secret = config.age.secrets."sing-box.json".path;
                quote = false;
              };
            };

            telemt = {
              enable = true;
              configFile = config.age.secrets."telemt.conf".path;
            };

            radicle = {
              privateKey = config.age.secrets."radicle.key".path;
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
