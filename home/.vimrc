" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Display
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set number
set nowrap
set list
"set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%

" Search
set ignorecase
set smartcase
set incsearch		" do incremental searching

" tabs
set expandtab
set tabstop=4

" Clipboard
set clipboard&
set clipboard^=unnamed
set clipboard^=unnamedplus

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" temporary settings
set noswapfile

" Examples

set history=50		" keep 50 lines of command line history

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

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

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

" Setting greo tools
if executable('hw')
  set grepprg=hw\ --no-group\ --no-color
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

