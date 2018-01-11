scriptencoding utf-8

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

"dein Scripts-----------------------------
" XDG Base Directory
let s:data_home =
      \ empty($XDG_DATA_HOME) ? expand('~/.local/share') : $XDG_DATA_HOME
let s:cache_home =
      \ empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:config_home =
      \ empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME

" dein Dirs
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:nvim_conf_dir = s:config_home . '/nvim'

" auto install
if !isdirectory(s:dein_repo) && executable('git')
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo
endif

if isdirectory(s:dein_repo)
  let &runtimepath = &runtimepath . ',' . s:dein_repo
  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    call dein#load_toml(s:nvim_conf_dir . '/dein.toml', {'lazy': 0})
    call dein#load_toml(s:nvim_conf_dir . '/deinlazy.toml', {'lazy': 1})

    call dein#end()
    call dein#save_state()
  endif
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
set list
set listchars=tab:¦-,trail:-,nbsp:+,extends:»,precedes:«
set colorcolumn=80

" Tab
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Search
set ignorecase
set smartcase

" Clipboard
set clipboard&
set clipboard^=unnamed
set clipboard^=unnamedplus

if executable('tig')
  nnoremap <silent> tig :<C-u>tabnew<CR>:te tig<CR>
endif

