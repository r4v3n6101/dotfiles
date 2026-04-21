{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.kernel-with-kvm = pkgs.stdenv.mkDerivation {
        pname = "apple-containerization-kernel";
        version = "6.18.5";

        src = ./../kernels/vmlinux;

        dontUnpack = true;

        installPhase = ''
          cp $src $out
        '';
      };
    };
}
