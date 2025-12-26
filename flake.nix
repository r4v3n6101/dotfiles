{
  description = "My NixOS/nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nixpkgs-torrserver.url = "github:r4v3n6101/nixpkgs/torrserver";
    flake-utils.url = "github:numtide/flake-utils";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        cl-nix-lite.url = "github:r4v3n6101/cl-nix-lite/url-fix";
      };
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
      nixpkgs-torrserver,
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
    in

    flake-utils.lib.eachDefaultSystem (
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
    )

    // {
      darwinConfigurations."r4mac" = nix-darwin.lib.darwinSystem {
        inherit specialArgs;

        system = "aarch64-darwin";
        modules = [
          {
            nixpkgs = {
              config.allowUnfree = true;
              overlays = [ ];
            };
          }

          ./machines/mac.nix

          home-manager.darwinModules.home-manager
          hmConfiguration
        ];
      };

      nixosConfigurations = {
        pvxsrv = nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          system = "x86_64-linux";
          modules = [
            ./machines/pvxsrv.nix
            ./machines/virt.nix
          ];
        };
        rpi4 = nixpkgs.lib.nixosSystem rec {
          inherit specialArgs;

          system = "aarch64-linux";
          modules = [
            {
              nixpkgs = {
                overlays = [
                  (final: prev: {
                    torrserver = nixpkgs-torrserver.legacyPackages.${system}.torrserver;
                  })
                ];
              };
            }
            ./machines/rpi4.nix
          ];
        };
      };
    };
}
