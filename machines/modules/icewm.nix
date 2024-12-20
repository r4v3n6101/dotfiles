{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    grim
    wl-clipboard
    vlc
    google-chrome
    alacritty
  ];

  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      windowManager = { icewm.enable = true; };
      xkb.layout = "us,ru";
      xkb.options = "grp:win_space_toggle";
    };
  };
}
