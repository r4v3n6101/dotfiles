{
  description = "My NixOS/nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nixpkgs-for-linux-builder.url = "github:nixos/nixpkgs/release-25.05";
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
    virby = {
      url = "github:quinneden/virby-nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-for-linux-builder
    , flake-utils
    , home-manager
    , nix-darwin
    , mac-app-util
    , nix-rosetta-builder
    , virby
    ,
    }:
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

      generic = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };

        in
        {
          formatter = pkgs.nixpkgs-fmt;
          devShells.default = pkgs.mkShell {
            buildInputs = [ pkgs.lua-language-server ];
          };
        }
      );

      darwinSystem =
        let
          system = "aarch64-darwin";
          pkgs-for-linux-builder = import nixpkgs-for-linux-builder { inherit system; };
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
                      linux-builder-stable-release = pkgs-for-linux-builder.darwin.linux-builder;
                    })
                  ];
                };
              }

              hmConfiguration
              ./machines/mac.nix

              home-manager.darwinModules.home-manager
              mac-app-util.darwinModules.default
              nix-rosetta-builder.darwinModules.default
              virby.darwinModules.default
            ];
          };
        };

    in
    generic // darwinSystem;
}
