{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  nix = {
    optimise.automatic = true;
    gc.automatic = true;
    settings = {
      trusted-users = [
        "@wheel"
        "root"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/vda";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  users.users.r4v3n6101 = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    hashedPassword = "$y$j9T$IEi9t/TtMnNXJNRGVHrBl.$CEln6XVeo9Bgl5FcguJi5UZm0V.w7HcTjf37QfAlxFB";
  };

  networking = {
    hostName = "linux";
  };

  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [ ];

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05";
}
