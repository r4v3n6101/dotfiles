{
  perSystem =
    { lib, pkgs, ... }:
    let
      version = "7.2.8";
      modDirVersion = "${version}-edge-sunxi64";
      packageVersion = "26.8.8_arm64__${version}-S9a66-Df596-P2c57-Cdc2a-H375c-HK01ba-Vc222-Bef2e-R448a";
      armbian = pkgs.callPackage (
        _:
        pkgs.runCommand "x96q-armbian-${version}"
          {
            inherit version;
            srcs = [
              (pkgs.fetchurl {
                url = "https://mirrors.dotsrc.org/armbian-apt/pool/main/l/linux-${version}/linux-image-edge-sunxi64_${packageVersion}.deb";
                hash = "sha256-DH11kDDC+lVN4ZkRrvMPRitXsAIZwgz598BMN14DeX8=";
              })
              (pkgs.fetchurl {
                url = "https://mirrors.dotsrc.org/armbian-apt/pool/main/l/linux-dtb-edge-sunxi64/linux-dtb-edge-sunxi64_${packageVersion}.deb";
                hash = "sha256-BB1HAfREM9nwDhwkICARghTURJJWsuEX3v5Ti4bV+mQ=";
              })
            ];
            nativeBuildInputs = [ pkgs.dpkg ];
            passthru = {
              inherit (pkgs) stdenv;
              inherit modDirVersion;
              target = "Image";
              configfile = "${armbian}/config";
              kernelOlder = lib.versionOlder version;
              kernelAtLeast = lib.versionAtLeast version;
              config =
                let
                  cfg = "\n" + builtins.readFile "${armbian}/config";
                in
                rec {
                  isSet = name: lib.hasInfix "\nCONFIG_${name}=" cfg;
                  isYes = name: lib.hasInfix "\nCONFIG_${name}=y\n" cfg;
                  isModule = name: lib.hasInfix "\nCONFIG_${name}=m\n" cfg;
                  isEnabled = name: isYes name || isModule name;
                };
            };
          }
          ''
            for src in $srcs; do
              dpkg-deb -x "$src" .
            done
            mkdir -p "$out"
            mv boot/vmlinuz-${modDirVersion} "$out/Image"
            mv boot/config-${modDirVersion} "$out/config"
            mv boot/dtb-${modDirVersion} "$out/dtbs"
            mv lib "$out/"
          ''
      ) { };
    in
    {
      packages.linux-armbian-sunxi64 = armbian;
    };
}
