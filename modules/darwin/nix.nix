{ ... }:
{
  flake.darwinModules.nix =
    { ... }:
    {
      nix = {
        enable = true;
        channel.enable = false;
        optimise.automatic = true;
        gc.automatic = true;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "@admin"
            "@wheel"
          ];
        };
      };
    };
}
