{ pkgs, ... }: {
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "Europe/Moscow";

  environment.systemPackages = with pkgs; [
    busybox
    git
    git-crypt
    gnupg
    htop
    xclip
    neovim
    inetutils
    pciutils
    usbutils
    ripgrep
  ];
  programs = {
    gnupg.agent.enable = true;
    ssh.startAgent = true;
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };
  };

  system.stateVersion = "23.11";
}
