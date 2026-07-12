{ config, pkgs, ... }: {
  imports = [
    ../home-manager/programs/direnv
    ../home-manager/programs/fish
    ../home-manager/programs/fzf
    ../home-manager/programs/ghq
    ../home-manager/programs/git
  ];
  home.packages = with pkgs; [
    nixd
    nixfmt
  ];
}
