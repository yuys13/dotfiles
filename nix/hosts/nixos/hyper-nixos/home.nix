{ pkgs, ... }: {
  imports = [
    ./sway.nix
  ];

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    nix-output-monitor
    p7zip
    unzip
    xz
    zip
  ];
}
