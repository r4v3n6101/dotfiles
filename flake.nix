{
  description = "My NixOS/nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils . url = "github:numtide/flake-utils";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, neovim-nightly-overlay, nix-darwin, home-manager }:
    let
      specialArgs = { inherit inputs; };

      hmConfiguration = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.backupFileExtension = "build";
        home-manager.users.r4v3n6101 = import ./profiles/personal.nix;
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

      linuxVm = flake-utils.lib.eachSystemPassThrough (with flake-utils.lib.system; [ x86_64-linux aarch64-linux ]) (system: {
        nixosConfigurations."${system}_vm" = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
            }
            ./machines/vm.nix
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
                overlays = [ neovim-nightly-overlay.overlays.default ];
                config.allowUnfree = true;
              };
            }
            ./machines/mac.nix

            home-manager.darwinModules.home-manager
            hmConfiguration
          ];
        };
      };

    in
    generic // linuxVm // darwinSystem;
}
