{ inputs, ... }:
{
  flake.homeModules.tools =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      isDarwin = pkgs.stdenv.isDarwin;
    in
    {
      imports = [
        inputs.nix-index-database.homeModules.default
      ];

      home = {
        sessionVariables =
          let
            tv-inline = pkgs.writeShellScriptBin "tv-inline" ''
              exec ${lib.getExe config.programs.television.package} --inline "$@"
            '';
          in
          {
            COMMA_PICKER = "${lib.getExe tv-inline}";
          };

        packages = with pkgs; [
          xdg-utils
          man-pages
          man-pages-posix
        ];
      };

      programs = {
        bash.enable = true;
        fish.enable = true;
        fd.enable = true;
        bat.enable = true;
        ripgrep.enable = true;
        gpg.enable = true;
        nh.enable = true;
        radicle.enable = true;
        codex.enable = true;

        nix-index-database.comma.enable = true;

        fastfetch = {
          enable = true;

          settings = {
            logo = {
              source = "${../../assets/spas-nerukotvorny.ansi}";
              type = "file-raw";
              padding = {
                right = 3;
              };
            };

            display = {
              separator = "  ";
              color = if isDarwin then "green" else "blue";
              size.binaryPrefix = "iec";
              key.width = 18;
            };

            modules = [
              "title"
              "separator"
              {
                type = "os";
                key = "󰣇 OS";
              }
              {
                type = "host";
                key = "󰌢 Host";
              }
              {
                type = "kernel";
                key = " Kernel";
              }
              {
                type = "uptime";
                key = "󰅐 Uptime";
              }
              {
                type = "packages";
                key = "󰏖 Packages";
              }
              "break"
              {
                type = "cpu";
                key = "󰍛 CPU";
                format = "{name:-32} ({cores-physical}C/{cores-logical}T)";
              }
              {
                type = "gpu";
                key = "󰢮 GPU";
                format = "{name:-32}";
              }
              {
                type = "memory";
                key = " Memory";
              }
              {
                type = "disk";
                key = "󰋊 Disk";
                folders = "/";
                format = "{size-used} / {size-total} ({size-percentage})";
              }
              {
                type = "display";
                key = "󰍹 Display";
                format = "{width}x{height} @ {refresh-rate} Hz";
              }
            ]
            ++ lib.optionals isDarwin [
              {
                type = "battery";
                key = "󰁹 Battery";
              }
              {
                type = "poweradapter";
                key = "󰚥 Adapter";
              }
            ]
            ++ lib.optionals (!isDarwin) [
              {
                type = "de";
                key = "󰧨 Desktop";
              }
              {
                type = "wm";
                key = "󰖲 WM";
              }
              {
                type = "swap";
                key = "󰓡 Swap";
              }
            ]
            ++ [
              "break"
              {
                type = "shell";
                key = " Shell";
              }
              {
                type = "terminal";
                key = " Terminal";
              }
              {
                type = "terminalfont";
                key = " Font";
              }
              "break"
              "colors"
            ];
          };
        };

        direnv = {
          enable = true;
          enableBashIntegration = true;
          enableFishIntegration = true;
          nix-direnv.enable = true;
        };

        man = {
          enable = true;
          generateCaches = true;
        };

        tealdeer = {
          enable = true;
          enableAutoUpdates = true;
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
          };
        };
      };
    };
}
