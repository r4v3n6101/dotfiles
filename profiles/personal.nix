{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.mac-app-util.homeManagerModules.default
  ];

  home = {
    stateVersion = "25.05";
    packages = with pkgs; [
      # Man pages
      tldr
      man-pages
      man-pages-posix

      # Main utils
      nmap
      iperf
      tree
      tokei

      # Neovim
      nil

      # Just software
      qbittorrent-enhanced
    ];
  };

  # Copy all neovim configs
  xdg.configFile.nvim = {
    source = ../programs/nvim;
    recursive = true;
  };

  programs = {
    bash.enable = true;
    fish.enable = true;
    tmux.enable = true;
    gpg.enable = true;
    nh.enable = true;
    bat.enable = true;
    btop.enable = true;
    fd.enable = true;
    ripgrep.enable = true;

    man = {
      enable = true;
      generateCaches = false;
    };

    television = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    nix-search-tv = {
      enable = true;
      enableTelevisionIntegration = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      signing = {
        signByDefault = true;
        format = lib.mkForce "openpgp";
        key = "8D1E07262DFDBD00";
      };
      settings = {
        init.defaultBranch = "master";
        commit.verbose = true;
        user = {
          name = "r4v3n6101";
          email = "raven6107@gmail.com";
        };
        push = {
          autoSetupRemote = true;
          followTags = true;
        };
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
        toggle_macos_secure_keyboard_entry = false;
        macos_quit_when_last_window_closed = true;
      };
    };
  };
}
