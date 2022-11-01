scriptencoding utf-8

lua << EOF
pcall(require, 'impatient')

-- packer bootstrap
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

if $COLORTERM =~? 'truecolor\|24bit'
  set termguicolors
endif

" Indent
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
inoremap <silent> jj <Esc>
autocmd MyAutoCmd TermOpen * tnoremap <buffer> jj <C-\><C-n>

if executable('tig')
  nnoremap <silent> <Space>tig <Cmd>tabnew<CR><Cmd>te tig<CR><Cmd>tunmap <buffer> jj<CR>i
endif

" Don't nest vim
if executable('nvr')
  let $EDITOR = 'nvr -cc split -c "set bufhidden=delete" --remote-wait'
endif

