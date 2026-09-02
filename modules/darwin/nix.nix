_:
{
  flake.darwinModules.nix =
    _:
    {
      nix = {
        enable = true;
        channel.enable = false;
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
