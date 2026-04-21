{ ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      packages.buildNixIndexDb = pkgs.stdenv.mkDerivation {
        name = "nix-index-db";
        dontUnpack = true;
        nativeBuildInputs = [ pkgs.nix-index ];
        buildPhase = "nix-index -d $out -f ${pkgs.path}";
      };
    };
}
