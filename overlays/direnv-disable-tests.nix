{ ... }:
{
  flake.overlays.direnv-disable-tests = final: prev: {
    direnv = prev.direnv.overrideAttrs (_: {
      doCheck = false;
    });
  };
}
