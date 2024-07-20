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
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager }:
    let overlays = [ (final: prev: { final.config.allowUnfree = true; }) ];
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
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.r4v3n6101 = import ./profiles/personal.nix;
          }
        ];
      };
    };
}
