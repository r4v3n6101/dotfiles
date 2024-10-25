{ pkgs, lib, ... }: {
  users.users.r4v3n6101 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };
}
