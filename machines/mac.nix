{ pkgs, inputs, ... }: {
  nix = {
    extraOptions = ''
      extra-platforms = aarch64-darwin x86_64-darwin
      experimental-features = nix-command flakes
    '';
    linux-builder.enable = true;
  };

  environment.systemPackages = with pkgs; [ neovim gnupg htop neofetch ];

  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true;
  };

  services.nix-daemon.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  system.configurationRevision = inputs.rev or inputs.dirtyRev or null;
  system.stateVersion = 4;
}
