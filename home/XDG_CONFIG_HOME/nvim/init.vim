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

" auto install
if !isdirectory(s:dein_repo) && executable('git')
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo
endif

if isdirectory(s:dein_repo)
  let &runtimepath = &runtimepath . ',' . s:dein_repo
  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    call dein#load_toml(expand('<sfile>:p:h') . '/dein.toml', {'lazy': 0})
    call dein#load_toml(expand('<sfile>:p:h') . '/deinlazy.toml', {'lazy': 1})

    if filereadable(expand('<sfile>:p:h') . '/local/dein.toml')
      call dein#load_toml(expand('<sfile>:p:h') . '/local/dein.toml',
            \ {'lazy': 0})
    endif
    if filereadable(expand('<sfile>:p:h') . '/local/deinlazy.toml')
      call dein#load_toml(expand('<sfile>:p:h') . '/local/deinlazy.toml',
            \ {'lazy': 1})
    endif

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
set cursorline

" Tab
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Search
set ignorecase
set smartcase
set inccommand=split

" Clipboard
set clipboard&
set clipboard^=unnamed
set clipboard^=unnamedplus

if executable('tig')
  nnoremap <silent> tig :<C-u>tabnew<CR>:te tig<CR>
endif

