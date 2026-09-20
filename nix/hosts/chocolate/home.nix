{ config, pkgs, ... }: {
  imports = [
    ../../nixos/home.nix
  ];

  home.username = "yuys13";
  home.homeDirectory = "/home/yuys13";
  home.stateVersion = "26.11";
}
