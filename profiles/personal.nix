{ pkgs, ... }: {
  home = {
    stateVersion = "23.11";
    sessionVariables = { EDITOR = "nvim"; };
    packages = with pkgs; [ tree tokei clang ripgrep lua-language-server ];
  };

  # Copy all neovim configs
  xdg.configFile.nvim = {
    source = ../programs/nvim;
    recursive = true;
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
      viAlias = true;
      vimAlias = true;
    };
  };
}
