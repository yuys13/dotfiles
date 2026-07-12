{ config, pkgs, ... }: {
  imports = [
    ../home-manager/programs/direnv
    ../home-manager/programs/fish
    ../home-manager/programs/fzf
  ];
  home.packages = with pkgs; [
    nixd
    nixfmt
  ];
}
