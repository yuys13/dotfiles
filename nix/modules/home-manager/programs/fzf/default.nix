{ lib, pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--layout reverse"
      "--height 40%"
    ];
    changeDirWidget = {
      command = "${lib.getExe pkgs.fd} -t d";
      options = [ "--preview '${lib.getExe pkgs.eza} --icons --tree --level=1 --color=always {}'" ];
    };
    fileWidget = {
      command = "${lib.getExe pkgs.fd} -t f -L -H -E .git";
      options = [
        "--preview '${lib.getExe pkgs.bat} --color=always --style=header,grid --line-range :100 {}'"
      ];
    };
  };
}
