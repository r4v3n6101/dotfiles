{ inputs, ... }:
{
  virtualisation.vmVariant.virtualisation.host.pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
}
