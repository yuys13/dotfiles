{ config, pkgs, ... }: {
  imports = [
    ../../home-manager/programs/direnv/defaults.nix
  ];

  home.username = "yuys13";
  home.homeDirectory = "/Users/yuys13";
  home.stateVersion = "26.11";
}
