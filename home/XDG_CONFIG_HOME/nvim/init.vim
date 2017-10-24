"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" XDG Base Directory
let s:data_home = empty($XDG_DATA_HOME) ? expand('~/.local/share') : $XDG_DATA_HOME
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME

" dein Dirs
let s:dein_dir = s:data_home . '/dein'
let s:dein_repo = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:dein_conf_dir = s:config_home . '/nvim/dein'

let &runtimepath = &runtimepath . "," . s:dein_repo

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call dein#load_toml(s:dein_conf_dir . '/dein.toml',      {'lazy' : 0})
  call dein#load_toml(s:dein_conf_dir . '/dein_lazy.toml', {'lazy' : 1})

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------

