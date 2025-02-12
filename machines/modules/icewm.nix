{ config, pkgs, lib, ... }: {
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    xserver = {
      enable = true;
      windowManager = { icewm.enable = true; };
      xkb.layout = "us,ru";
      xkb.options = "grp:win_space_toggle";
    };
  };
}
