{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, rust-overlay }:
    let
      overlays = [
        rust-overlay.overlays.default
        (final: prev: { final.config.allowUnfree = true; })
      ];
      homeManagerPersonal = { specialArgs }: { };
    in {
      darwinConfigurations."r4mac" = nix-darwin.lib.darwinSystem rec {
        specialArgs = { inherit inputs; };
        modules = [
          {
            nixpkgs = {
              inherit overlays;
              hostPlatform = "aarch64-darwin";
            };
            users.users.r4v3n6101.home = "/Users/r4v3n6101";
          }
          ./machines/mac.nix
          home-manager.darwinModules.home-manager
          ({ pkgs, ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs // {
              customRustBuild = pkgs.rust-bin.fromRustupToolchainFile
                ./programs/rust/apple-silicon-nightly.toml;
            };
            home-manager.users.r4v3n6101 = import ./profiles/personal.nix;
          })
        ];
      };
    };
}
