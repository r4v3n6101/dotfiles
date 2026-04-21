{ inputs, lib, ... }:
{
  imports = [
    inputs.nix-darwin.flakeModules.default
    inputs.home-manager.flakeModules.home-manager
  ];
  options.flake = {
    # Darwin modules (for nix-darwin)
    # nix-darwin.flakeModules.default only provides flake.darwinConfigurations
    # so we need to define darwinModules ourselves for reusable modules
    darwinModules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
      description = "Darwin system modules";
    };
  };
}
