{ pkgs, lib, ... }: {
  imports = [
    ./modules/fs.nix
    ./modules/base.nix
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

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-autorandr.enable = true;
    spice-webdavd.enable = true;
  };

  networking.hostName = "vm";
  users.users.r4v3n6101 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };
}
