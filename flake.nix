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
  };

  outputs = inputs@{ self, nixpkgs, neovim-nightly-overlay, nix-darwin, home-manager }:
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
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;

      nixosConfigurations.aarch64_vm = nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        system = "aarch64-linux";
        modules = [
          {
            nixpkgs.config.allowUnfree = true;
          }
          ./machines/vm.nix
        ];
      };

      nixosConfigurations.x86_vm = nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        system = "x86_64-linux";
        modules = [
          {
            nixpkgs.config.allowUnfree = true;
          }
          ./machines/vm.nix
        ];
      };

      darwinConfigurations."r4mac" = nix-darwin.lib.darwinSystem {
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

          home-manager.darwinModules.home-manager
          hmConfiguration
        ];
      };
    };
}
