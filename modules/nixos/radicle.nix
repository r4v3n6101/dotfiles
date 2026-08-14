{ ... }:
{
  flake.nixosModules = {
    radicle-seed-node =
      { config, pkgs, ... }:
      let
        hostname = "radicle.${config.networking.domain}";
        web-app = pkgs.radicle-explorer.withConfig {
          preferredSeeds = [
            {
              inherit hostname;

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

            settings.node = {
              alias = config.networking.domain;
              seedingPolicy = {
                default = "block";
                scope = "follow";
              };
            };
          };

          caddy.virtualHosts.${hostname}.extraConfig = ''
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
