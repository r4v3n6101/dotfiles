{ ... }: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-partlabel/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/BOOT";
      fsType = "vfat";
    };
  };
}
