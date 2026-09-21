{ pkgs, ... }: {
  imports = [
    ./programs/bat
    ./programs/direnv
    ./programs/fish
    ./programs/fzf
    ./programs/gh
    ./programs/ghq
    ./programs/git
    ./programs/herdr
    ./programs/neovim
    ./programs/pip
    ./programs/tig
  ];

  home.packages = with pkgs; [
    betterleaks
    btop
    eza
    fastfetch
    fd
    jq
    pinact
    ripgrep
    tokei
    vhs
  ];
}
