{ pkgs, lib, ... }: {
  imports = [
    ./modules/fs.nix
    ./modules/base.nix
    ./modules/users.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.firmware = [ pkgs.linux-firmware ];
}
