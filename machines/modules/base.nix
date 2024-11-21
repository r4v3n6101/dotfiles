{ pkgs, lib, ... }: {
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "Europe/Moscow";
  i18n = {
    supportedLocales = [ "all" ];
    defaultLocale = "C.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    dig
    wget
    tmux
    htop
    lm_sensors
    nmap
    ffmpeg-full
    yt-dlp
    iperf
    xclip
    neovim
    inetutils
    pciutils
    usbutils
    libimobiledevice
    ifuse
  ];

  users.defaultUserShell = pkgs.fish;

  programs = {
    fish.enable = true;
    direnv.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      ports = [ 30000 ];
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "yes";
      };
    };
    usbmuxd.enable = true;
  };

  nix = {
    optimise.automatic = true;
    gc.automatic = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };
  };

  system.stateVersion = "23.11";
}
