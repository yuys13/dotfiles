{ pkgs, ... }:
{
  home.packages = with pkgs; [ ghq ];

  programs.git.settings.ghq.root = "~/src";
}
