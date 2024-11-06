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
      settings = {
        Peers = [
          # Russia
          "tls://s-mow-1.sergeysedoy97.ru:65534"
          "quic://srv.itrus.su:7993"
          # Germany
          "quic://ygg-uplink.thingylabs.io:443"
          "tcp://193.107.20.230:7743"
          # Netherlands
          "quic://vpn.itrus.su:7993"
          "ws://vpn.itrus.su:7994"
        ];
      };
    };
    logind.lidSwitch = "ignore";
  };
}
