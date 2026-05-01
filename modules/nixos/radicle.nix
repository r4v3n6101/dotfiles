{ ... }:
{
  flake.nixosModules.radicle-seed-node =
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
          openFirewall = true;
          virtualHosts."radicle.${config.networking.domain}".extraConfig = ''
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
}
