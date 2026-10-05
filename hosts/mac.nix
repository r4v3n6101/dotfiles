{
  config,
  inputs,
  ...
}:
let
  inherit (config.flake.modules) darwin homeManager;
  user = "r4v3n6101";
in
{
  flake = {
    darwinConfigurations.r4mac = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        darwin.nix
        darwin.r4mac
        darwin.customization
      ];
    };

    modules.darwin.r4mac =
      { pkgs, ... }:
      {
        imports = [
          inputs.mac-app-util.darwinModules.default
          inputs.home-manager.darwinModules.home-manager
          "${inputs.nix-darwin-yggdrasil}/modules/services/yggdrasil.nix"
        ];

        nix.linux-builder = {
          enable = true;
          ephemeral = true;
          systems = [
            "aarch64-linux"
            "x86_64-linux"
          ];

          package = pkgs.darwin.linux-builder-vz;
          config = {
            nix.settings.build-dir = "/nix/.rw-store/build";
            services.logind.settings.Login = {
              IdleAction = "poweroff";
              IdleActionSec = "15min";
            };
            virtualisation = {
              cores = 6;
              darwin-builder = {
                memorySize = 8 * 1024;
                diskSize = 100 * 1024;
              };
            };
          };
        };

        system = {
          stateVersion = 6;
          primaryUser = user;
        };

        users.users.${user} = {
          home = "/Users/${user}";
          shell = pkgs.fish;
          openssh.authorizedKeys.keyFiles = [
            ../keys/id_termius.pub
          ];
        };

        networking = {
          computerName = "🫨💼";
          hostName = "r4mac";
          wakeOnLan.enable = true;
        };

        security.pam.services.sudo_local.touchIdAuth = true;

        environment = with pkgs; {
          shells = [
            fish
          ];
          systemPackages = [
            (lib.hiPrio pkgs.uutils-coreutils-noprefix)
            iina

            # Only client
            openssh
          ];
        };

        programs.fish.enable = true;

        services = {
          openssh.enable = true;

          yggdrasil = {
            enable = true;
            settings = {
              Peers = [
                "tcp://ygg-msk-1.averyan.ru:8363"
                "tcp://yggno.de:18226"
                "tcp://box.paulll.cc:13337"
              ];
            };
          };
        };

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit inputs;
          };
          backupFileExtension = "build";
          users.${user}.imports = [
            inputs.mac-app-util.homeManagerModules.default
            { home.stateVersion = "25.11"; }

            homeManager.tools
            homeManager.kitty
            homeManager.nixvim
          ];
        };
      };
  };
}
