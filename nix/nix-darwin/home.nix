{ config, pkgs, ... }: {
  imports = [
    ../home-manager/programs/direnv
    ../home-manager/programs/fish
    ../home-manager/programs/fzf
    ../home-manager/programs/ghq
    ../home-manager/programs/git
    ../home-manager/programs/neovim
  ];
  home.packages = with pkgs; [
    gh
  ];
}
