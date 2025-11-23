{
  description = "My NixOS/nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        cl-nix-lite.url = "github:r4v3n6101/cl-nix-lite/url-fix";
      };
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "git+ssh://git@github.com/r4v3n6101/secrets.git";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      flake-utils,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      specialArgs = { inherit inputs; };

      hmConfiguration = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialArgs;
          backupFileExtension = "build";
          users.r4v3n6101 = import ./profiles/personal.nix;
        };
      };

      generic = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };

        in
        {
          formatter = pkgs.nixfmt-tree;
          devShells.default = pkgs.mkShell {
            buildInputs = [ pkgs.lua-language-server ];
          };
        }
      );

      darwinSystem =
        let
          system = "aarch64-darwin";
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
        in
        {
          darwinConfigurations."r4mac" = nix-darwin.lib.darwinSystem {
            inherit specialArgs system;
            modules = [
              {
                nixpkgs = {
                  config.allowUnfree = true;
                  overlays = [
                    (final: prev: {
                      darwin = prev.darwin.overrideScope (
                        final: prev: {
                          linux-builder = pkgs-unstable.darwin.linux-builder;
                        }
                      );
                    })
                  ];
                };
              }

              ./machines/mac.nix

              home-manager.darwinModules.home-manager
              hmConfiguration
            ];
          };
        };

      pvxsrv =
        let
          system = "x86_64-linux";
        in
        {
          nixosConfigurations.pvxsrv = nixpkgs.lib.nixosSystem {
            inherit specialArgs system;
            modules = [
              ./machines/pvxsrv.nix
              ./machines/virt.nix
            ];
          };
        };

    in
    generic // darwinSystem // pvxsrv;
}
