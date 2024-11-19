{ pkgs, ... }: {
  home = {
    stateVersion = "23.11";
    sessionVariables = { EDITOR = "nvim"; };
    packages = with pkgs; [ tree tokei ripgrep lua-language-server ];
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
      "E04D21AA50401B5B50A33197228E62F0FEC4BBED"
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
        key = "0D87F470A4316B35";
      };
    };

    neovim = {
      viAlias = true;
      vimAlias = true;
    };
  };
}
