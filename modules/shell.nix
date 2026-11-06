{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          config.agenix-rekey.package
          pkgs.deploy-rs
        ];
      };
    };
}
