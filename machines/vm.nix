{ pkgs, lib, ... }: {
  imports = [
    ./modules/fs.nix
    ./modules/base.nix
    ./modules/icewm.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    firmware = [ pkgs.linux-firmware ];
  };

  networking.hostName = "vm";
  users.users.r4v3n6101 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };
}
