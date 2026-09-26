{ config, pkgs, ... }: {
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git.ignores = [
    ".envrc"
    ".direnv/"
  ];
}
