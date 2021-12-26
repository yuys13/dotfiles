-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

local packer = require 'packer'

local init = function()
  local use = packer.use
  -- Packer can manage itself
  use {
    'wbthomason/packer.nvim',
    opt = true,
  }

  use {
    'neovim/nvim-lspconfig',
    config = function()
      require 'rc.lspconfig'
    end,
    requires = {
      { 'williamboman/nvim-lsp-installer' },
      { 'folke/lua-dev.nvim' },
    },
  }

  use 'hrsh7th/cmp-nvim-lsp'

  use {
    'hrsh7th/nvim-cmp',
    opt = true,
    event = 'InsertEnter',
    config = function()
      require 'rc.nvim-cmp'
    end,
    requires = {
      { 'hrsh7th/vim-vsnip', opt = true },
      { 'hrsh7th/vim-vsnip-integ', opt = true },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
    },
  }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      local null_ls = require 'null-ls'
      null_ls.setup {
        -- you can reuse a shared lspconntomljkjk on_attach callback here
        on_attach = function(client)
          if client.resolved_capabilities.document_formatting then
            vim.cmd 'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'
          end
        end,
        sources = {
          -- Dockerfile
          null_ls.builtins.diagnostics.hadolint,
          -- Fish shell
          null_ls.builtins.formatting.fish_indent,
          -- Go
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.goimports,
          -- Javascript
          null_ls.builtins.formatting.prettier.with { prefer_local = 'node_modules/.bin' },
          -- Lua
          null_ls.builtins.diagnostics.luacheck.with {
            condition = function(utils)
              return utils.root_has_file { '.luacheckrc' }
            end,
          },
          null_ls.builtins.formatting.stylua,
          -- Markdown
          null_ls.builtins.diagnostics.markdownlint,
          -- Python
          null_ls.builtins.diagnostics.flake8,
          -- null_ls.builtins.diagnostics.pylint,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          -- null_ls.builtins.formatting.reorder_python_imports,
          -- Rust
          null_ls.builtins.formatting.rustfmt,
          -- Shell script
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.formatting.shfmt.with {
            condition = function(utils)
              return not utils.root_has_file { '.editorconfig' }
            end,
            extra_args = { '-i', '4' },
          },
          -- Vim script
          null_ls.builtins.diagnostics.vint,
          -- YAML
          null_ls.builtins.diagnostics.yamllint,

          -- Git
          null_ls.builtins.code_actions.gitsigns,
        },
      }
    end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    config = function()
      require 'rc.telescope'
    end,
    setup = function()
      vim.api.nvim_set_keymap('n', '<Space>ff', '<Cmd>Telescope find_files<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Space>fb', '<Cmd>Telescope buffers<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Space>fr', '<Cmd>Telescope resume<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Space>fg', '<Cmd>Telescope git_files<CR>', { noremap = true, silent = true })

      vim.api.nvim_set_keymap('n', '<Space>f*', '<Cmd>Telescope grep_string<CR>', { noremap = true, silent = true })

      vim.api.nvim_set_keymap('n', '<Space>fh', '<Cmd>Telescope help_tags<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Space>fcs', '<Cmd>Telescope colorscheme<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'FT', '<Cmd>Telescope filetypes<CR>', { noremap = true, silent = true })

      vim.api.nvim_set_keymap('n', '<Space>f:', '<Cmd>Telescope command_history<CR>', { noremap = true, silent = true })

      vim.api.nvim_set_keymap(
        'n',
        '<Space>/',
        '<Cmd>Telescope current_buffer_fuzzy_find<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap('n', '<Space>f/', '<Cmd>Telescope live_grep<CR>', { noremap = true, silent = true })
    end,
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'folke/trouble.nvim' },
      { 'kyazdani42/nvim-web-devicons' },
    },
  }

  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    setup = function()
      -- Lua
      vim.api.nvim_set_keymap('n', '<Space>xx', '<cmd>Trouble<cr>', { silent = true, noremap = true })
      vim.api.nvim_set_keymap(
        'n',
        '<Space>xw',
        '<cmd>Trouble workspace_diagnostics<cr>',
        { silent = true, noremap = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<Space>xd',
        '<cmd>Trouble document_diagnostics<cr>',
        { silent = true, noremap = true }
      )
      -- vim.api.nvim_set_keymap('n', '<Space>xl', '<cmd>Trouble loclist<cr>', { silent = true, noremap = true })
      -- vim.api.nvim_set_keymap('n', '<Space>xq', '<cmd>Trouble quickfix<cr>', { silent = true, noremap = true })
      vim.api.nvim_set_keymap('n', 'gR', '<cmd>Trouble lsp_references<cr>', { silent = true, noremap = true })
    end,
    config = function()
      require('trouble').setup {
        use_diagnostic_signs = true,
      }
    end,
  }

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use { 'dracula/vim', as = 'dracula', config = 'vim.cmd[[colorscheme dracula]]' }
  use { 'cocopon/iceberg.vim', opt = true }
  use { 'jonathanfilip/vim-lucius', opt = true }
  use { 'junegunn/seoul256.vim', opt = true }
  use { 'joshdick/onedark.vim', opt = true }
  use { 'tomasr/molokai', opt = true }
  use {
    'altercation/vim-colors-solarized',
    opt = true,
    config = function()
      vim.cmd [[
            if empty($SOLARIZED)
              let g:solarized_termtrans = 0
              let g:solarized_termcolors = 256
            else
              let g:solarized_termtrans = 1
              let g:solarized_termcolors = 16
              set background=dark
              autocmd MyAutoCmd VimEnter * nested colorscheme solarized
              endif
              ]]
    end,
  }

  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      vim.o.showmode = false
      require('lualine').setup {
        options = {
          icons_enabled = false,
          section_separators = '',
          component_separators = '',
        },
      }
    end,
  }
  use 'editorconfig/editorconfig-vim'

  use {
    'yuys13/partedit.vim',
    setup = 'vim.cmd[[nmap <silent> <Space>pe <Plug>(partedit_start_context)]]',
    requires = { { 'Shougo/context_filetype.vim' } },
  }

  use 'tpope/vim-fugitive'
  -- use 'airblade/vim-gitgutter'
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
          change = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
          delete = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
          topdelete = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
          changedelete = {
            hl = 'GitSignsChange',
            text = '~',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn',
          },
        },
        keymaps = {},
      }
    end,
  }

  use {
    'kannokanno/previm',
    -- cmd = 'PrevimOpen',
    requires = 'tyru/open-browser.vim',
  }

  use {
    'tyru/open-browser.vim',
    setup = function()
      vim.cmd [[
            let g:netrw_nogx = 1 " disable netrw's gx mapping.
            nmap gx <Plug>(openbrowser-smart-search)
            vmap gx <Plug>(openbrowser-smart-search)
            ]]
    end,
  }

  use {
    'Yggdroot/indentLine',
    setup = function()
      vim.cmd [[
            let g:indentLine_showFirstIndentLevel = 1
            let g:indentLine_bufTypeExclude = ['nofile', 'help']
            let g:indentLine_fileTypeExclude = ['']
  
            function! s:myIndentLineReset() abort
              if exists('b:indentLine_enabled') ? b:indentLine_enabled :
                    \ get(g:, 'indentLine_enabled', 0)
                IndentLinesReset
              endif
            endfunction
  
            " for vim-precious
            autocmd MyAutoCmd User PreciousFileType call s:myIndentLineReset()
            ]]
    end,
  }

  use {
    't9md/vim-quickhl',
    setup = function()
      vim.cmd [[
              nmap <Space>hl <Plug>(quickhl-manual-this)
              nmap <Space>nohl <Plug>(quickhl-manual-reset)
            ]]
    end,
  }

  use {
    'kassio/neoterm',
    setup = function()
      vim.cmd [[
            nnoremap <Space>nl :<C-u>rightbelow vertical Tnew<CR>
            nnoremap <Space>nh :<C-u>vertical Tnew<CR>
            nmap <Space>nn <Plug>(neoterm-repl-send-line)
            vmap <Space>nn <Plug>(neoterm-repl-send)
          ]]
    end,
  }

  use {
    'terrortylor/nvim-comment',
    config = function()
      require('nvim_comment').setup()
    end,
  }

  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'

  use {
    'liuchengxu/vista.vim',
    cmd = 'Vista',
    setup = function()
      vim.g.vista_default_executive = 'nvim_lsp'
    end,
  }

  use {
    'cohama/lexima.vim',
  }
end

return packer.startup {
  function()
    init()
  end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    },
  },
}
