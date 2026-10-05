_: {
  flake.modules.darwin.nix = _: {
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
