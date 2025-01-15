{ pkgs, inputs, ... }: {
  system.stateVersion = 4;

  nix = {
    optimise.automatic = true;
    gc.automatic = true;
    extraOptions = ''
      extra-platforms = aarch64-darwin x86_64-darwin
      experimental-features = nix-command flakes
    '';
  };

  users.users.r4v3n6101 = {
    home = "/Users/r4v3n6101";
    shell = pkgs.fish;
  };

  security.pam.enableSudoTouchIdAuth = true;

  networking = {
    computerName = "🫨💼";
    hostName = "r4mac";
    wakeOnLan.enable = true;
  };

  environment.shells = [ pkgs.fish ];

  programs = {
    fish.enable = true;
    direnv.enable = true;
    # HM won't run it for some reason, so run system wide
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    nix-daemon.enable = true;
    openssh.enable = true;
  };


  system = {
    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyleSwitchesAutomatically = true;
        AppleICUForce24HourTime = false;
        "com.apple.keyboard.fnState" = false;
        "com.apple.sound.beep.feedback" = 1;
      };
      dock = {
        magnification = true;
        mineffect = "genie";
        minimize-to-application = true;
        persistent-apps = [
          "/System/Cryptexes/App/System/Applications/Safari.app"
          "/System/Applications/Messages.app"
          "/System/Applications/FaceTime.app"
          "/System/Applications/Photos.app"
          "/System/Applications/Music.app"
          "/System/Applications/Calendar.app"
          "/System/Applications/Reminders.app"
          "/System/Applications/Notes.app"
          "/System/Applications/Mail.app"
          "/System/Applications/System Settings.app"
        ];
        show-recents = false;
        showhidden = true;
      };
      menuExtraClock = {
        FlashDateSeparators = false;
        Show24Hour = false;
        ShowAMPM = true;
        ShowSeconds = true;
      };
      finder = {
        FXRemoveOldTrashItems = true;
        FXPreferredViewStyle = "icnv";
        NewWindowTarget = "Home";
        ShowPathbar = true;
        _FXSortFoldersFirst = true;
      };
      ".GlobalPreferences"."com.apple.mouse.scaling" = -1.0;
    };
  };
}
