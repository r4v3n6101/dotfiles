{ pkgs, lib, ... }: {
  imports = [ ./modules/fs.nix ./modules/base.nix ./modules/users.nix ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.logind.lidSwitch = "ignore";
  networking.hostName = "a9";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.firmware = [ pkgs.linux-firmware ];
}
