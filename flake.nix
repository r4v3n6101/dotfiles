{
  description = "My NixOS/nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    virby.url = "github:quinneden/virby-nix-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix/master";
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
        rpi4 = nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          system = "aarch64-linux";
          modules = [
            ./machines/rpi4.nix
          ];
        };
      };
    };
}
