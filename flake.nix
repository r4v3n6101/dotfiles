{
  description = "My NixOS/nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nixpkgs, neovim-nightly-overlay, nix-darwin, home-manager, nix-homebrew }:
    let
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
          {
            nixpkgs = {
              overlays = [ neovim-nightly-overlay.overlays.default ];
              config.allowUnfree = true;
            };
          }
          ./machines/a9.nix

          home-manager.nixosModules.home-manager
          hmConfiguration
        ];
      };

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
      darwinConfigurations."r4mac" = nix-darwin.lib.darwinSystem rec {
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

          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "r4v3n6101";
            };
          }

          home-manager.darwinModules.home-manager
          hmConfiguration
        ];
      };
    };
}

