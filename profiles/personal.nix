{ pkgs, ... }: {
  home = {
    stateVersion = "23.11";
    packages = with pkgs; [ tmux tree tokei ripgrep lua-language-server htop nmap iperf ];
  };

  # Copy all neovim configs
  xdg.configFile.nvim = {
    source = ../programs/nvim;
    recursive = true;
  };

  programs = {
    fish.enable = true;

    gpg.enable = true;

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
      package = pkgs.neovim;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableBashIntegration = true;
    enableScDaemon = true;
    pinentryPackage = pkgs.pinentry-curses;
    sshKeys = [
      "B31A6DC9FACA32FBBF211AC441F830B2E9C0BD43"
    ];
  };
}
