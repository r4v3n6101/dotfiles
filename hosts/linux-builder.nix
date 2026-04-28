{ inputs, self, ... }:
{
  flake = {
    nixosConfigurations.linux-builder = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        self.nixosModules.linux-builder
      ];
    };

    nixosModules.linux-builder =
      { ... }:
      {
        nix = {
          channel.enable = false;
          registry.nixpkgs.flake = inputs.nixpkgs;
          settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
        };

        networking.useDHCP = true;

        services = {
          getty.autologinUser = "root";
          openssh = {
            enable = true;
            settings = {
              PermitRootLogin = "yes";
              PasswordAuthentication = false;
            };
          };
        };

        users = {
          allowNoPasswordLogin = true;
          users.root = {
            isSystemUser = true;
            openssh.authorizedKeys.keyFiles = [
              ../keys/microvm-builder.pub
            ];
          };
        };

        virtualisation.rosetta.enable = true;

        system.stateVersion = "25.11";
      };
  };
}
