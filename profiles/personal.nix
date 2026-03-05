{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  buildNixIndexDb = pkgs.stdenv.mkDerivation {
    name = "nix-index-db";
    dontUnpack = true;
    nativeBuildInputs = [ pkgs.nix-index ];
    buildPhase = "nix-index -d $out -f ${pkgs.path}";
  };
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.mac-app-util.homeManagerModules.default
  ];

  sops = {
    gnupg.home = config.programs.gpg.homedir;
    secrets = {
      "context7.key" = {
        format = "binary";
        sopsFile = "${inputs.secrets}/home-manager/context7.key";
      };
    };
  };

  home = {
    stateVersion = "25.05";
    sessionVariables = {
      CONTEXT7_API_KEY = "$(cat ${config.sops.secrets."context7.key".path})";
      NIX_INDEX_DATABASE = "${buildNixIndexDb}/";
    };
    packages = with pkgs; [
      # Man pages
      man-pages
      man-pages-posix

      # Some utils
      xdg-utils
      (comma.overrideAttrs (prev: {
        patches = [ ./tv_inline.patch ];
        postPatch = ''
          substituteInPlace ./src/main.rs \
            --replace-fail '"nix-locate"' '"${lib.getExe' nix-index-unwrapped "nix-locate"}"' \
            --replace-fail '"nix"' '"${lib.getExe nix}"' \
            --replace-fail '"nix-env"' '"${lib.getExe' nix "nix-env"}"' \
            --replace-fail '"fzy"' '"${lib.getExe config.programs.television.package}"'
        '';
      }))

      # Neovim
      nil
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

    nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
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

    man = {
      enable = true;
      generateCaches = true;
    };

    tealdeer = {
      enable = true;
      enableAutoUpdates = true;
    };

    nix-search-tv = {
      enable = true;
      enableTelevisionIntegration = true;
    };

    television = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings.shell_integration.channel_triggers = {
        tldr = [ "tldr" ];
        git-branch = [
          "git checkout"
        ];
        git-diff = [
          "git add"
          "git restore"
        ];
        git-log = [
          "git log"
          "git show"
        ];
        nixpkgs = [
          "nix shell"
          "nix run"
          "nix develop"
          "nix profile add"
        ];
      };
      channels = {
        nixpkgs = {
          metadata = {
            name = "nixpkgs";
            description = "Search nixpkgs";
            requirements = [
              "sed"
              "nix-search-tv"
              "xdg-open"
            ];
          };

          # Retain only packages, not options
          source.command = [
            "nix-search-tv print | grep -E '^nixpkgs' | sed 's|/ |#|'"
            "nix-search-tv print | grep -E '^nur' | sed 's|/ |#|'"
          ];
          preview.command = "nix-search-tv preview --indexes {split:#:0} '{split:#:1}'";
          actions.homepage = {
            description = "Open homepage";
            command = "nix-search-tv homepage --indexes {split:#:0} '{split:#:1}' | xargs xdg-open";
          };
          actions.source = {
            description = "Open source";
            command = "nix-search-tv source --indexes {split:#:0} '{split:#:1}' | xargs xdg-open";
          };
        };
      };
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

    codex = {
      enable = true;
      enableMcpIntegration = true;
    };

    mcp = {
      enable = true;
      servers = {
        context7 = {
          url = "https://mcp.context7.com/mcp";
          headers = {
            CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
          };
        };
      };
    };
  };
}
