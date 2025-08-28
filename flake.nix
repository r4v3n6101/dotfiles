{
  description = "My NixOS/nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, nix-darwin, home-manager, mac-app-util }:
    let
      specialArgs = { inherit inputs; };

      hmConfiguration = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialArgs;
          backupFileExtension = "build";
          sharedModules = [ mac-app-util.homeManagerModules.default ];
          users.r4v3n6101 = import ./profiles/personal.nix;
        };
      };

      generic = flake-utils.lib.eachDefaultSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system};

        in {
          formatter = pkgs.nixpkgs-fmt;
          devShells.default = pkgs.mkShell {
            buildInputs = [
              pkgs.lua-language-server
            ];
          };
        });

      darwinSystem = {
        darwinConfigurations."r4mac" = nix-darwin.lib.darwinSystem {
          inherit specialArgs;

          system = "aarch64-darwin";
          modules = [
            {
              nixpkgs = {
                overlays = [ ];
                config.allowUnfree = true;
              };
            }
            ./machines/mac.nix

            home-manager.darwinModules.home-manager
            hmConfiguration

            mac-app-util.darwinModules.default
          ];
        };
      };

    in
    generic // darwinSystem;
}
