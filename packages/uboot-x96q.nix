{
  perSystem =
    { pkgs, ... }:
    {
      packages.uboot-x96q =
        pkgs.runCommand "u-boot-x96q-2026.10"
          {
            src = pkgs.fetchurl {
              url = "https://github.com/warpme/miniarch/releases/download/acbde2881da/MiniArch-15.4.0-05.08.2026-7.3.1-board-h313.x96_q_lpddr3-SD-Image.img.xz";
              hash = "sha256-Gk70WBKEm47VSGaQ/4RNu3wo3ggAuq+lKgpKshJZOaE=";
            };
            nativeBuildInputs = [ pkgs.xz ];
          }
          ''
            xz -dc "$src" > image
            dd if=image of="$out" bs=1M skip=8192 count=931497 \
              iflag=skip_bytes,count_bytes status=none
          '';
    };
}
