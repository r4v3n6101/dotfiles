{
  config,
  inputs,
  withSystem,
  ...
}:
let
  mkProfile =
    name:
    let
      host = config.flake.nixosConfigurations.${name};
      deployPkgs = withSystem host.pkgs.stdenv.hostPlatform.system (
        { pkgs, ... }:
        pkgs.appendOverlays [
          inputs.deploy-rs.overlays.default
          (_: prev: {
            deploy-rs = {
              inherit (pkgs) deploy-rs;
              inherit (prev.deploy-rs) lib;
            };
          })
        ]
      );
    in
    {
      user = "root";
      confirmTimeout = 60;
      path = deployPkgs.deploy-rs.lib.activate.nixos host;
    };
in
{
  flake.deploy.nodes = {
    pvxsrv = {
      hostname = "pvxsrv";
      sshUser = "admin";
      profiles.system = mkProfile "pvxsrv";
    };

    rpi4 = {
      hostname = "rpi4";
      sshUser = "r4v3n6101";
      profiles.system = mkProfile "rpi4";
    };

    x96q = {
      hostname = "x96q";
      sshUser = "r4v3n6101";
      profiles.system = mkProfile "x96q";
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.deploy-rs = pkgs.deploy-rs;
    };
}
