{ pkgs, ... }:
{
  programs.herdr = {
    enable = true;
    settings = {
      keys = {
        command = [
          {
            key = "prefix+ctrl+g";
            type = "pane";
            command = "${pkgs.tig}/bin/tig";
          }
        ];
        prefix = "ctrl+q";
      };
      onboarding = false;
      terminal = {
        default_shell = "${pkgs.fish}/bin/fish";
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
