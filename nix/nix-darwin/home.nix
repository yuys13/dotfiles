{ config, pkgs, ... }: {
  imports = [
    ../home-manager/programs/direnv
  ];
  home.packages = with pkgs; [
    nixd
    nixfmt
  ];
}
