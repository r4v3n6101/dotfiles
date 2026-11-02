{
  flake.modules.darwin.nix = {
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
