scriptencoding utf-8

lua pcall(require, 'impatient')

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

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

" Mouse
set mouse=a

" Keymap
imap <silent> jj <Esc>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
autocmd MyAutoCmd TermOpen * tnoremap <buffer> jj <C-\><C-n>

if executable('nvr')
  let $EDITOR = 'nvr -cc split -c "set bufhidden=delete" --remote-wait'
endif

if executable('tig')
  nnoremap <silent> <Space>tig <Cmd>tabnew<CR>:te tig<CR>:tunmap <buffer> jj<CR>i
endif

lua << EOF
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
  require('rc.packer').sync()
end
EOF

command! PackerInstall packadd packer.nvim | lua require('rc.packer').install()
command! PackerUpdate packadd packer.nvim | lua require('rc.packer').update()
command! PackerSync packadd packer.nvim | lua require('rc.packer').sync()
command! PackerClean packadd packer.nvim | lua require('rc.packer').clean()
command! PackerCompile packadd packer.nvim | lua require('rc.packer').compile()
command! PackerStatus packadd packer.nvim | lua require('rc.packer').status()

augroup packer_user_config
  autocmd!
  autocmd BufWritePost packer.lua source <afile> | PackerCompile
augroup end

