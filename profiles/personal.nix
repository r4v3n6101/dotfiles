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
    pinentryPackage = pkgs.pinentry-curses;
    sshKeys = [
      "0E843183132D66EB88F277CCD456B950A2A2C83F"
      "3A9816E4CBC252B8DB6B16D6AAD6015A6BB1D3E8"
    ];
  };

  programs = {
    gpg.enable = true;

    git = {
      enable = true;
      userName = "r4v3n6101";
      userEmail = "raven6107@gmail.com";
      extraConfig = { init.defaultBranch = "master"; };
      signing = {
        signByDefault = true;
        key = "4D87A757C10D8905";
      };
    };

    neovim = {
      viAlias = true;
      vimAlias = true;
    };
  };
}
