{ pkgs, ... }: {
  imports = [
    ../home-manager
  ];
  home.packages = with pkgs; [
    eza
    fd
    jq
  ];
}
