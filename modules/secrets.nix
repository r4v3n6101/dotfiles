{ inputs, ... }:
{
  imports = [ inputs.agenix-rekey.flakeModule ];

  perSystem =
    { config, pkgs, ... }:
    {
      agenix-rekey.extraDecryptionArgs = [
        "-j"
        "gpg"
      ];

      devShells.default = pkgs.mkShell {
        packages = [
          config.agenix-rekey.package
        ];
      };
    };
}
