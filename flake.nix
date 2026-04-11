{
  description = "My NixOS/nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-apple-container = {
      url = "github:halfwhey/nix-apple-container";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    virby = {
      url = "github:quinneden/virby-nix-darwin/be170bd7ef21ce9773e7daa646d43f5405a1bdb2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";

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
      home-manager,
      nix-darwin,
      ...
    }:
    let
      specialArgs = { inherit inputs; };
    in
    {
      darwinConfigurations."r4mac" = nix-darwin.lib.darwinSystem {
        inherit specialArgs;

        system = "aarch64-darwin";
        modules = [
          ./machines/mac.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs = {
              config.allowUnfree = true;
              overlays = [
                (final: prev: {
                  nix-index = prev.nix-index.override {
                    nix-index-unwrapped = prev.nix-index-unwrapped.overrideAttrs (oldAttrs: rec {
                      src = prev.fetchFromGitHub {
                        owner = "nix-community";
                        repo = "nix-index";
                        rev = "6e6ec6ffd9c318f5bce0f891eeaab0e89d1f12eb";
                        hash = "sha256-Z5IWhtoaU9gNsE8IWO9lWg2O9mjSgMCF3LpPR/YAwGI=";
                      };
                      patches = [
                        ./packages/patches/rust-tls-non-native.patch
                      ];
                      cargoDeps = prev.rustPlatform.fetchCargoVendor {
                        inherit src patches;

                        hash = "sha256-irSlOSfSF0B7h95AsHk/EMPjgrFJCFD3RytC7FwoQlA=";
                      };
                    });
                  };
                })
              ];
            };
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              backupFileExtension = "build";
              users.r4v3n6101 = import ./profiles/personal.nix;
            };
          }
        ];
      };

      nixosConfigurations = {
        pvxsrv = nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          system = "x86_64-linux";
          modules = [
            ./machines/pvxsrv.nix
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
