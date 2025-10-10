{ pkgs, ... }: {

  nix = {
    enable = true;
    optimise.automatic = true;
    gc.automatic = true;
    settings = {
      trusted-users = [ "root" "@admin" ];
    };
    extraOptions = ''
      extra-platforms = aarch64-darwin x86_64-darwin
      experimental-features = nix-command flakes
    '';
    linux-builder = {
      # Not needed rn
      enable = false;
      ephemeral = true;
      maxJobs = 8;
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
    };
  };

  users.users.r4v3n6101 = {
    home = "/Users/r4v3n6101";
    shell = pkgs.fish;
  };

  networking = {
    computerName = "🫨💼";
    hostName = "r4mac";
    wakeOnLan.enable = true;
  };

  environment = with pkgs; {
    shells = [ fish ];
    systemPackages = [
      (lib.hiPrio pkgs.uutils-coreutils-noprefix)
      iina
      google-chrome
    ];
  };

  programs.fish.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    stateVersion = 6;

    # Will be removed in the future when all of attributes go away from system-wide config
    primaryUser = "r4v3n6101";

    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleICUForce24HourTime = false;
        "com.apple.sound.beep.feedback" = 1;
      };
      dock = {
        magnification = true;
        mineffect = "genie";
        minimize-to-application = true;
        persistent-apps = [
          "/System/Cryptexes/App/System/Applications/Safari.app"
          "${pkgs.telegram-desktop}/Applications/Telegram.app"
          "/System/Applications/Phone.app"
          "/System/Applications/FaceTime.app"
          "/System/Applications/Messages.app"
          "/System/Applications/Music.app"
          "/System/Applications/TV.app"
          "/System/Applications/Podcasts.app"
          "/System/Applications/Photos.app"
          "/System/Applications/Calendar.app"
          "/System/Applications/Reminders.app"
          "/System/Applications/Notes.app"
          "/System/Applications/Mail.app"
        ];
        persistent-others = [
          "/Users/r4v3n6101/Downloads/"
        ];
        show-recents = true;
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
