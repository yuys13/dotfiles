{ pkgs, ... }:
{
  home.packages = with pkgs; [ tig ];
  xdg.configFile."tig/config".source = ../../../../home/XDG_CONFIG_HOME/tig/config;
}
