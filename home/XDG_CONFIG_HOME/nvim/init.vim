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

let s:dein_toml = expand('<sfile>:p:h') . '/dein.toml'
let s:deinlazy_toml = expand('<sfile>:p:h') . '/deinlazy.toml'

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

" Display
set number
set nowrap
set list
set listchars=tab:¦-,trail:-,nbsp:+,extends:»,precedes:«
set colorcolumn=80
set cursorline

let g:vimsyn_embrd = 'lPr'

autocmd MyAutoCmd TermOpen * setlocal nonumber
autocmd MyAutoCmd TermOpen * setlocal norelativenumber

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

" Keymap
inoremap <silent> jj <Esc>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
autocmd MyAutoCmd TermOpen * tnoremap <buffer> jj <C-\><C-n>

if executable('nvr')
  let $EDITOR = 'nvr -cc split -c "set bufhidden=delete" --remote-wait'
endif

if executable('tig')
  nnoremap <silent> <Space>tig :<C-u>tabnew<CR>:te tig<CR>:tunmap <buffer> jj<CR>
endif

