{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--layout reverse"
      "--height 40%"
    ];
    changeDirWidget = {
      command = "fd -t d";
      options = [ "--preview 'eza --icons --tree --level=1 --color=always {}'" ];
    };
    fileWidget = {
      command = "fd -t f -L -H -E .git";
      options = [
        "--preview 'bat --color=always --style=header,grid --line-range :100 {}'"
      ];
    };
  };
}
