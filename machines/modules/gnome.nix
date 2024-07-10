{ pkgs, lib, ... }: {
  environment = {
    defaultPackages = with pkgs; [ google-chrome telegram-desktop ];
    gnome = {
      excludePackages = (with pkgs; [ gnome-tour gedit epiphany ])
        ++ (with pkgs.gnome; [
          gnome-characters
          gnome-music
          iagno
          hitori
          atomix
        ]);
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services = {
    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    udev = { packages = with pkgs; [ gnome.gnome-settings-daemon ]; };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  systemd.services = { NetworkManager-wait-online.wantedBy = lib.mkForce [ ]; };
}
