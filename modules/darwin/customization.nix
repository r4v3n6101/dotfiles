{ ... }:
{
  flake.darwinModules.customization =
    { pkgs, ... }:
    {
      system.defaults = {
        NSGlobalDomain = {
          AppleInterfaceStyle = "Dark";
          AppleICUForce24HourTime = false;
          "com.apple.sound.beep.feedback" = 1;
        };
        dock = {
          autohide = true;
          autohide-delay = 0.0;
          autohide-time-modifier = 1.0;
          largesize = 105;
          magnification = true;
          mineffect = "genie";
          minimize-to-application = true;
          persistent-apps = [
            "/System/Cryptexes/App/System/Applications/Safari.app"
            "${pkgs.telegram-desktop}/Applications/Telegram.app"
            "/System/Applications/Messages.app"
            "/System/Applications/Music.app"
            "/System/Applications/Calendar.app"
            "/System/Applications/Reminders.app"
            "/System/Applications/Notes.app"
            "/System/Applications/Mail.app"
          ];
          persistent-others = [
            "/Users/r4v3n6101/Downloads/"
          ];
          show-recents = false;
          showhidden = true;
        };
        menuExtraClock = {
          FlashDateSeparators = false;
          Show24Hour = false;
          ShowAMPM = true;
          ShowSeconds = true;
          ShowDate = 0;
          ShowDayOfMonth = true;
          ShowDayOfWeek = true;
        };
        finder = {
          FXDefaultSearchScope = "SCcf";
          FXRemoveOldTrashItems = true;
          FXPreferredViewStyle = "icnv";
          NewWindowTarget = "Home";
          ShowPathbar = true;
          _FXSortFoldersFirst = true;
          _FXSortFoldersFirstOnDesktop = true;
          ShowExternalHardDrivesOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
        };
        loginwindow = {
          DisableConsoleAccess = true;
          RestartDisabled = true;
          ShutDownDisabled = true;
          PowerOffDisabledWhileLoggedIn = true;
          ShutDownDisabledWhileLoggedIn = true;
          RestartDisabledWhileLoggedIn = true;
        };
      };
    };
}
