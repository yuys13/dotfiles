" If you want to use dark power, delete me
scriptencoding utf-8

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" Keymap
inoremap <silent> jj <ESC>
inoremap <C-v>u <C-r>=nr2char(0x)<Left>
nnoremap Y y$

set backspace=indent,eol,start

" Display
set ruler
set showcmd
set number
set nowrap
set list
"set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%
set colorcolumn=80
set cursorline
set breakindent
set showbreak=↪

set diffopt&
set diffopt+=vertical

autocmd MyAutoCmd VimResized * wincmd =
" syntax=OFF in large files
autocmd MyAutoCmd BufReadPost * if getfsize(@%) > 512 * 1024 | setlocal syntax=OFF | call interrupt() | endif

" Search
set ignorecase
set smartcase
set incsearch

" Indent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Clipboard
set clipboard&
set clipboard^=unnamed
set clipboard^=unnamedplus

" Cmdline completion
set wildmenu
set wildmode=longest,full
set wildoptions=pum

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has('gui_running')
  syntax on
  set hlsearch
endif

" temporary settings
set noswapfile

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Misc
set updatetime=500
set confirm

" Only do this part when compiled with support for autocommands.
if has('autocmd')

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
          \ if line("'\"") >= 1 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif

  augroup END

  augroup BinaryXXD
    autocmd!
    "autocmd BufReadPre *.bin let &binary =1
    autocmd BufReadPost * if &binary && &modifiable | silent %!xxd -g 1
    autocmd BufReadPost * set ft=xxd | endif
    autocmd BufWritePre * if &binary && &modifiable | silent %!xxd -r
    autocmd BufWritePre * endif
    autocmd BufWritePost * if &binary && &modifiable | silent %!xxd -g 1
    autocmd BufWritePost * set nomod | endif
  augroup END

else

  set autoindent

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(':DiffOrig')
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

" Setting grep tools
if executable('rg')
  let &grepprg = 'rg --vimgrep --smart-case --hidden'
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('hw')
  set grepprg=hw\ --no-group\ --no-color
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

colorscheme habamax

