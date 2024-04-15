{ pkgs, lib, ... }: {
  imports = [
    ./modules/fs.nix
    ./modules/base.nix
    ./modules/gnome.nix
    ./modules/users.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.firmware = with pkgs; [
      linux-firmware
      sof-firmware 
  ];

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  services.tailscale.enable = true;
}

