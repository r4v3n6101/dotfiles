{ pkgs, lib, ... }: {
  imports = [
    ./modules/fs.nix
    ./modules/base.nix
    ./modules/users.nix
    ./modules/icewm.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "a9";

  environment.systemPackages = with pkgs; [ bluetuith ];

  hardware = {
    firmware = [ pkgs.linux-firmware ];
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services = {
    yggdrasil = {
      enable = true;
      persistentKeys = true;
      settings = { Peers = [ "tcp://srv.itrus.su:7991" ]; };
    };
    logind.lidSwitch = "ignore";
  };
}
