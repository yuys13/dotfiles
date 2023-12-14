scriptencoding utf-8

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" Keymap
inoremap <silent> jj <Esc>
autocmd MyAutoCmd TermOpen * tnoremap <buffer> jj <C-\><C-n>
inoremap <C-v>u <C-r>=nr2char(0x)<Left>

if executable('tig')
  nnoremap <silent> <Space>tig <Cmd>tabnew<CR><Cmd>te tig<CR><Cmd>tunmap <buffer> jj<CR>i
endif

" Abbr
cnoreabbrev qa confirm qall

" Display
set number
set nowrap
set list
set listchars=tab:¦-,trail:-,nbsp:+,extends:»,precedes:«
set colorcolumn=80
set cursorline
set breakindent
set showbreak=↪

set diffopt&
set diffopt+=vertical

let g:vimsyn_embed = 'lPr'

autocmd MyAutoCmd TermOpen * setlocal nonumber
autocmd MyAutoCmd TermOpen * setlocal norelativenumber

if $COLORTERM ==? 'truecolor'
  set termguicolors
endif

autocmd MyAutoCmd VimResized * wincmd =

" Search
set ignorecase
set smartcase
set inccommand=split

" Indent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Clipboard
set clipboard&
set clipboard^=unnamed
set clipboard^=unnamedplus

" Mouse
set mouse=a

" Misc
set updatetime=500

" Don't nest neovim
if executable('nvr')
  let $EDITOR = 'nvr -cc split -c "set bufhidden=delete" --remote-wait'
endif
unlet $MANPAGER

" Setting grep tools
if executable('rg')
  let &grepprg = 'rg --vimgrep --smart-case --hidden'
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Auto mkdir
augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)  " {{{
    if !isdirectory(a:dir) && (a:force ||
    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}

lua pcall(require, 'rc.lazy')
