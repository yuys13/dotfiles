{ pkgs, ... }:
let
  # Build merged SKK dictionary at build time
  merged-skk-jisyo = pkgs.stdenv.mkDerivation {
    name = "merged-skk-jisyo";
    nativeBuildInputs = [ pkgs.skktools ];
    dontUnpack = true;
    installPhase = with pkgs.skkDictionaries; ''
      mkdir -p $out
      skkdic-expr2 \
        ${l}/share/skk/SKK-JISYO.L \
        + ${jinmei}/share/skk/SKK-JISYO.jinmei \
        + ${geo}/share/skk/SKK-JISYO.geo \
        + ${station}/share/skk/SKK-JISYO.station \
        + ${propernoun}/share/skk/SKK-JISYO.propernoun \
        + ${zipcode}/share/skk/SKK-JISYO.zipcode \
        + ${zipcode}/share/skk/SKK-JISYO.office.zipcode \
        > $out/SKK-JISYO.L
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
