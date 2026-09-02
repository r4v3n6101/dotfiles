{
  inputs,
  self,
  ...
}:
let
  user = "r4v3n6101";
in
{
  flake = {
    darwinConfigurations.r4mac = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        self.darwinModules.nix
        self.darwinModules.r4mac
        self.darwinModules.customization
      ];
    };

    darwinModules.r4mac =
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
          maxJobs = 4;
          systems = [
            "aarch64-linux"
            "x86_64-linux"
          ];

          package = pkgs.darwin.linux-builder-vz;
          config.virtualisation = {
            cores = 6;

            darwin-builder = {
              memorySize = 6 * 1024;
              diskSize = 100 * 1024;
            };
          };
        };

        nixpkgs.overlays = [ ];

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

            self.homeModules.tools
            self.homeModules.kitty
            self.homeModules.nixvim
          ];
        };
      };
  };
}
