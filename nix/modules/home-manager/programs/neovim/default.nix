{ pkgs, ... }:
let
  # Build merged SKK dictionary at build time
  merged-skk-jisyo = pkgs.stdenv.mkDerivation {
    name = "merged-skk-jisyo";
    nativeBuildInputs = [ pkgs.skktools ];
    dicts = with pkgs.skkDictionaries; [
      l
      jinmei
      geo
      station
      propernoun
      zipcode
    ];
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out
      args=""
      for dict in $dicts; do
        jisyo=$(find $dict -name "SKK-JISYO.*" | head -n 1)
        if [ -n "$args" ]; then
          args="$args + $jisyo"
        else
          args="$jisyo"
        fi
      done
      skkdic-expr2 $args > $out/SKK-JISYO.L
    '';
  };
in
{
  # Link the merged dictionary to the expected path
  home.file.".local/share/nvim/eskk/SKK-JISYO.L".source = "${merged-skk-jisyo}/SKK-JISYO.L";

  programs.git.ignores = [
    ".nvim.lua"
    ".nvimrc"
    ".exrc"
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = false;
    withRuby = false;
    sideloadInitLua = true;

    extraPackages = with pkgs; [
      gcc
      gitlint
      lua-language-server
      neovim-remote
      nil
      nixd
      nixfmt
      selene
      stylua
      tree-sitter
      vscode-langservers-extracted
      yaml-language-server
    ];
  };
}
