{ pkgs, lib, ... }: {
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
    usePredictableInterfaceNames = true;
  };

  time.timeZone = "Europe/Moscow";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    git
    git-crypt
    gnupg
    htop
    neovim
    inetutils
    pciutils
    usbutils
  ];
  programs.gnupg.agent.enable = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };
  };

  system.stateVersion = "23.11";
}
