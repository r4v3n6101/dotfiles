{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = { self, nixpkgs-stable, home-manager }@attrs: 
  {
    nixosConfigurations.msi = nixpkgs-stable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./machines/msi.nix
	home-manager.nixosModules.home-manager
        {
	  home-manager.useUserPackages = true;
	  home-manager.useGlobalPkgs = true;
	  home-manager.users = {
	    r4v3n6101 = import ./profiles/personal.nix;
	    ak = {
	      imports = [
	        ./profiles/work.nix
	        ./profiles/workbench.nix
	      ];
	    };
	  };
	}
      ];
    };
  };
}
