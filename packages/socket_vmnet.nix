{ stdenv, lib, fetchFromGitHub, git, logger }:
stdenv.mkDerivation rec {
  pname = "socket_vmnet";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "socket_vmnet";
    rev = "v${version}";
    sha256 = "sha256-MbmfCS8gG7XVbG7mVXGen7F/chEIyTvWSoHfwIiF+2s=";
  };

  nativeBuildInputs = [ git logger ];

  installPhase = ''
    mkdir -p $out/bin
    make install.bin PREFIX=$out
  '';

  meta = with lib; {
    description = "Connect ot root vmnet from userspace";
    homepage = "https://github.com/lima-vm/socket_vmnet";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.darwin;
  };
}

