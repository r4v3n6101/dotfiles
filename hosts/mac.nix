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
        self.darwinModules.microvm-builder
      ];
    };

    darwinModules.r4mac =
      { pkgs, ... }:
      {
        imports = [
          inputs.mac-app-util.darwinModules.default
          inputs.home-manager.darwinModules.home-manager
          ../yank/yggdrasil.nix
        ];

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
                "tcp://ip4.01.msk.ru.dioni.su:9002"
                "tcp://yggdrasil.1337.moe:7676"
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
