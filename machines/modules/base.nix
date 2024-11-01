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
    gnupg
    htop
    neovim
    inetutils
    pciutils
    usbutils
    libimobiledevice
    ifuse
    bluetuith
  ];

  programs = {
    gnupg.agent.enable = true;
    direnv.enable = true;
  };

  hardware = {
    bluetooth = {
        enable = true;
        powerOnBoot = true;
    };
  };

  services = {
    openssh.enable = true;
    usbmuxd.enable = true;
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };
  };

  system.stateVersion = "23.11";
}
