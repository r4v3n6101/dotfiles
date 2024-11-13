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
    let
      overlays = [ (final: prev: { final.config.allowUnfree = true; }) ];
      specialArgs = { inherit inputs; };
      hmConfiguration = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.backupFileExtension = "build";
        home-manager.users.r4v3n6101 = import ./profiles/personal.nix;
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      nixosConfigurations.a9 = nixpkgs.lib.nixosSystem rec {
        inherit specialArgs;

        system = "x86_64-linux";
        modules = [
          ./machines/a9.nix
          home-manager.nixosModules.home-manager
          hmConfiguration
        ];
      };

      darwinConfigurations."r4mac" = nix-darwin.lib.darwinSystem rec {
        inherit specialArgs;

        system = "aarch64-darwin";
        modules = [
          { users.users.r4v3n6101.home = "/Users/r4v3n6101"; }
          ./machines/mac.nix
          home-manager.darwinModules.home-manager
          hmConfiguration
        ];
      };
    };
}

