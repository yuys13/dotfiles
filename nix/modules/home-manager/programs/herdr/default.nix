{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.herdr = {
    enable = true;
    settings = {
      keys = {
        command = [
          {
            key = "prefix+ctrl+g";
            type = "pane";
            command = lib.getExe pkgs.tig;
          }
        ];
        prefix = "ctrl+q";
      };
      onboarding = false;
      terminal = {
        default_shell = lib.getExe config.programs.fish.package;
      };
      ui = {
        status_indicators = "symbols";
      };
      update = {
        version_check = false;
      };
    };
  };
}
