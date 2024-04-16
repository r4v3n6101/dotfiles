{ pkgs, lib, ... }: {
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
    usePredictableInterfaceNames = true;
  };

  time.timeZone = "Europe/Moscow";

  environment.systemPackages = with pkgs; [
    git
    git-crypt
    gnupg
    htop
    xclip
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
