{ inputs, lib, ... }:
{
  virtualisation.vmVariant = {
    virtualisation = {
      cores = 8;
      memorySize = 8 * 1024;
      host.pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
      writableStoreUseTmpfs = false;
      qemu.networkingOptions = lib.mkForce [
        "-device virtio-net-pci,netdev=user.0"
        ''-netdev vmnet-shared,id=user.0,"$QEMU_NET_OPTS"''
      ];
    };
  };
}
