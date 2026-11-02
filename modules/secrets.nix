{ inputs, ... }:
{
  imports = [ inputs.agenix-rekey.flakeModule ];

  perSystem =
    { config, ... }:
    {
      agenix-rekey.extraDecryptionArgs = [
        "-j"
        "gpg"
      ];

      packages.agenix = config.agenix-rekey.package;
    };
}
