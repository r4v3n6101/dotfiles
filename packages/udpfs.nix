_: {
  perSystem = { pkgs, self', ... }: {
    packages.udpfsd = pkgs.buildGoModule {
      pname = "udpfsd";
      version = "whocares";

      src = pkgs.fetchFromGitHub {
        owner = "pcm720";
        repo = "udpfsd";
        rev = "58d7c8f11ac196d4a5ca7b65b78743fbeedfdd80";
        hash = "sha256-z0WaZFvK6SQq626mGVe2EggoY2wowqZiEsShgN5hLbo=";
      };

      vendorHash = "sha256-0NjdihN5+EB7LBtBZKh1+725CjQCuLJ9KRECm0Md2jA=";

      env.CGO_ENABLED = "0";

      subPackages = [
        "cmd/udpfsd"
      ];
    };

    apps.ps2-serve = {
      type = "app";
      program = "${
        pkgs.writeShellApplication {
          name = "ps2-serve";

          runtimeInputs = [
            self'.packages.udpfsd
          ];

          text = ''
            exec udpfsd -fsroot "''${1:-$PWD/games}" -ro
          '';
        }
      }/bin/ps2-serve";
    };
  };
}
