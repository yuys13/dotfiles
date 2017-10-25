"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" XDG Base Directory
let s:data_home = empty($XDG_DATA_HOME) ? expand('~/.local/share') : $XDG_DATA_HOME
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME

" dein Dirs
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:dein_conf_dir = s:config_home . '/nvim/dein'

" auto install
if !isdirectory(s:dein_repo)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo))
endif

let &runtimepath = &runtimepath . "," . s:dein_repo

if isdirectory(s:dein_repo) && dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call dein#load_toml(s:dein_conf_dir . '/plugins.toml')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

" install not installed plugins on startup.
if isdirectory(s:dein_repo) && dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

" Display
set number
set nowrap
set tabstop=4
set list
set listchars=tab:»-,trail:-,nbsp:+,extends:»,precedes:«

" Search
set ignorecase
set smartcase

" Clipboard
set clipboard&
set clipboard^=unnamed
set clipboard^=unnamedplus

