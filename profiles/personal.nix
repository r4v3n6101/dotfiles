{ pkgs, ... }: {
  home = {
    stateVersion = "23.11";
    packages = with pkgs; [
      neofetch
      # Man pages
      man-pages
      man-pages-posix
      # Main utils I use
      htop
      nmap
      iperf
      tmux
      tree
      tokei
      # Neovim
      nixd
    ];
  };

  # Copy all neovim configs
  xdg.configFile.nvim = {
    source = ../programs/nvim;
    recursive = true;
  };

  programs = {
    fish.enable = true;
    gpg.enable = true;
    ripgrep.enable = true;
    man = {
      enable = true;
      generateCaches = false;
    };
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      userName = "r4v3n6101";
      userEmail = "raven6107@gmail.com";
      extraConfig = { init.defaultBranch = "master"; };
      signing = {
        signByDefault = true;
        key = "4C51A28DF1BBAECC";
      };
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;
    };
    kitty = {
      enable = true;
      enableGitIntegration = true;
      font = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font Mono Regular";
        size = 18;
      };
      shellIntegration = {
        enableFishIntegration = true;
        enableBashIntegration = true;
      };
      settings = {
        remember_window_size = true;
        remember_window_position = false;
        macos_option_as_alt = true;
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableScDaemon = true;
    pinentry.package = pkgs.pinentry-tty;
    sshKeys = [
      "B31A6DC9FACA32FBBF211AC441F830B2E9C0BD43"
    ];
  };
}
