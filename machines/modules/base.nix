{ pkgs, lib, ... }: {
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "Europe/Moscow";
  i18n = {
    supportedLocales = [ "all" ];
    defaultLocale = "en_US.UTF-8";
  };

  environment.systemPackages = with pkgs; [
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
