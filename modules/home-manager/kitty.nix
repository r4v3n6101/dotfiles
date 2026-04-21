{ ... }:
{
  flake.homeModules.kitty =
    { pkgs, ... }:
    {
      programs.kitty = {
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
