{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, rust-overlay }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    nixosConfigurations.msi = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = rec {
        overlays = [
          (import rust-overlay)
          # Fucking bullshit company
          (final: prev: {
            jetbrains-toolbox = prev.jetbrains-toolbox.overrideAttrs (oa: {
              src =
                oa.src.overrideAttrs { curlOpts = "-x http://127.0.0.1:1080"; };
            });
          })
        ];

        pkgs = import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };
        pkgs-stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
        customRustBuild = pkgs.pkgsBuildHost.rust-bin.fromRustupToolchainFile
          ./rust-toolchain.toml;
      };
      modules = [
        ./machines/msi.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users = {
            r4v3n6101 = import ./profiles/personal.nix;
            ak = {
              imports = [ ./profiles/work.nix ./profiles/workbench.nix ];
            };
          };
        }
      ];
    };
  };
}
