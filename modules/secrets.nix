{ inputs, ... }:
{
  imports = [ inputs.agenix-rekey.flakeModule ];

  perSystem.agenix-rekey.extraDecryptionArgs = [
    "-j"
    "gpg"
  ];
}
