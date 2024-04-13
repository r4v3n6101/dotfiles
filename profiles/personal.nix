{ lib, pkgs, ... }: {
  home = {
    stateVersion = "23.11";
    packages = with pkgs; [
      rustup
    ];
  };

  programs.git = {
    enable = true;
    userName = "r4v3n6101";
    userEmail = "raven6107@gmail.com";
    extraConfig = {
      init.defaultBranch = "master";
    };
    signing = {
      signByDefault = true;
      key = "4D87A757C10D8905";
    };
  };
}
