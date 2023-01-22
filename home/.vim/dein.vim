"dein Scripts-----------------------------
if has('nvim')
  let s:dein_dir = stdpath('cache') . '/dein'
else
  " XDG Base Directory
  let s:data_home =
        \ empty($XDG_DATA_HOME) ? expand('~/.local/share') : $XDG_DATA_HOME
  let s:cache_home =
        \ empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
  let s:config_home =
        \ empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME

  " dein Dirs
  let s:dein_dir = s:cache_home . '/vim/dein'
endif

let s:dein_repo = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

let s:dein_toml = expand('<sfile>:p:h') . '/dein.toml'
let s:deinlazy_toml = expand('<sfile>:p:h') . '/deinlazy.toml'

"
let g:dein#install_progress_type = 'floating'
let g:dein#install_check_diff = v:true
let g:dein#auto_recache = v:true

" auto install
if !isdirectory(s:dein_repo) && executable('git')
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo
endif

if isdirectory(s:dein_repo)
  let &runtimepath = &runtimepath . ',' . s:dein_repo
  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir, [$MYVIMRC, s:dein_toml, s:deinlazy_toml])

    call dein#load_toml(s:dein_toml, {'lazy': 0})
    call dein#load_toml(s:deinlazy_toml, {'lazy': 1})

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

