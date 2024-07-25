{ pkgs, ... }: {
  home = {
    stateVersion = "23.11";
    sessionVariables = { EDITOR = "nvim"; };
    packages = with pkgs; [ tree tokei ripgrep lua-language-server direnv ];
  };

  # Copy all neovim configs
  xdg.configFile.nvim = {
    source = ../programs/nvim;
    recursive = true;
  };

  programs = {
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
