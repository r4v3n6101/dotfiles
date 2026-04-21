{ ... }:
{
  flake.overlays.nix-index-master = final: prev: {
    nix-index = prev.nix-index.override {
      nix-index-unwrapped = prev.nix-index-unwrapped.overrideAttrs (oldAttrs: rec {
        src = prev.fetchFromGitHub {
          owner = "nix-community";
          repo = "nix-index";
          rev = "0f68b51886bde4014629e43d9be4b66cff450990";
          hash = "sha256-polUDx4tWFmyxsn83XRrw9YQlDq/ggNY1hq6xw9NOoQ=";
        };
        cargoDeps = prev.rustPlatform.fetchCargoVendor {
          inherit src;

          hash = "sha256-2Ar7mj9r5eKdbXDC4+jSWG7HvGFTeowEPt2SBM6a6e4=";
        };
      });
    };
  };
}
