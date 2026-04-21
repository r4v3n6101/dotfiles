{ self, ... }:
{
  flake.homeModules.tools =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      home = {
        sessionVariables =
          let
            tv-inline = pkgs.writeShellScriptBin "tv-inline" ''
              exec ${lib.getExe config.programs.television.package} --inline "$@"
            '';
          in
          {
            NIX_INDEX_DATABASE = "${self.packages.${pkgs.stdenv.hostPlatform.system}.buildNixIndexDb}/";
            COMMA_PICKER = "${lib.getExe tv-inline}";
          };

        packages = with pkgs; [
          comma
          xdg-utils
          man-pages
          man-pages-posix
        ];
      };

      programs = {
        bash.enable = true;
        fish.enable = true;
        tmux.enable = true;
        gpg.enable = true;
        bat.enable = true;
        btop.enable = true;
        fd.enable = true;
        ripgrep.enable = true;
        nh.enable = true;
        radicle.enable = true;
        codex.enable = true;

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
