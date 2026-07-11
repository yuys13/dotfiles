{ config, pkgs, ... }: {
  imports = [
    ../../nix-darwin/home.nix
  ];

  home.username = "yuys13";
  home.homeDirectory = "/Users/yuys13";
  home.stateVersion = "26.11";
}
