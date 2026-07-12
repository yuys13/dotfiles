{ config, pkgs, ... }: {
  imports = [
    ../home-manager/programs/direnv
    ../home-manager/programs/fish
  ];
  home.packages = with pkgs; [
    nixd
    nixfmt
  ];
}
