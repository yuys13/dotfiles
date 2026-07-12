{ pkgs, ... }:
let
  sources = pkgs.callPackage ../../../../_sources/generated.nix { };
in
{
  programs.fish = {
    enable = true;
    functions = {
      vi = {
        wraps = "$EDITOR";
        description = "alias vi $EDITOR";
        body = ''
          if test -z "$EDITOR"
              command vi $argv
          else
              eval $EDITOR $argv
          end
        '';
      };
    };
    plugins = [
      {
        name = sources.fish-autols.pname;
        src = sources.fish-autols.src;
      }
      {
        name = sources.fish-cdf.pname;
        src = sources.fish-cdf.src;
      }
      {
        name = sources.fish-fzf-bd.pname;
        src = sources.fish-fzf-bd.src;
      }
      {
        name = sources.fish-gcd.pname;
        src = sources.fish-gcd.src;
      }
      {
        name = sources.fish-pathed.pname;
        src = sources.fish-pathed.src;
      }
      {
        name = sources.fish-ghq-fzf.pname;
        src = sources.fish-ghq-fzf.src;
      }
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
    interactiveShellInit = ''
      # Workaround for tide prompt icon issue in fish 4.3+
      set -gx tide_character_vi_icon_default "❯"
    '';
  };
}
