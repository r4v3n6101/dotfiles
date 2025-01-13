{ pkgs, inputs, ... }: {
  system.stateVersion = 4;

  nix = {
    optimise.automatic = true;
    gc.automatic = true;
    extraOptions = ''
      extra-platforms = aarch64-darwin x86_64-darwin
      experimental-features = nix-command flakes
    '';
  };

  users.users.r4v3n6101 = {
    home = "/Users/r4v3n6101";
    shell = pkgs.fish;
  };

  security.pam.enableSudoTouchIdAuth = true;

  networking = {
    computerName = "🫨💼";
    hostName = "r4mac";
  };

  environment.shells = [ pkgs.fish ];

  programs = {
    fish.enable = true;
    direnv.enable = true;
    # HM won't run it for some reason, so run system wide
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    nix-daemon.enable = true;
  };
}
