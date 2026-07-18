{ config, pkgs, ... }: {
  imports = [
    ../home-manager/programs/bat
    ../home-manager/programs/direnv
    ../home-manager/programs/fish
    ../home-manager/programs/fzf
    ../home-manager/programs/ghq
    ../home-manager/programs/git
    ../home-manager/programs/herdr
    ../home-manager/programs/neovim
    ../home-manager/programs/pip
    ../home-manager/programs/tig
  ];
  home.packages = with pkgs; [
    gh
    ripgrep
  ];
}
