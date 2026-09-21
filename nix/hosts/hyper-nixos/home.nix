{ config, pkgs, ... }: {
  imports = [
    ../../nixos/home.nix
    ./sway.nix
  ];

  home.username = "yuys13";
  home.homeDirectory = "/home/yuys13";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    nix-output-monitor
    p7zip
    unzip
    xz
    zip
  ];
}
