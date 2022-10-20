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

  use { 'lewis6991/impatient.nvim' }

  use {
    'neovim/nvim-lspconfig',
    config = function()
      require 'rc.lspconfig'
    end,
    requires = {
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'folke/neodev.nvim' },
      { 'b0o/SchemaStore.nvim' },
      { 'lukas-reineke/lsp-format.nvim' },
    },
  }

  use {
    'ray-x/lsp_signature.nvim',
    config = function()
      require('lsp_signature').setup()
    end,
  }

  use {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup {
        fmt = {
          stack_upwards = false,
        },
      }
    end,
  }

  use {
    'hrsh7th/nvim-cmp',
    config = function()
      require 'rc.nvim-cmp'
    end,
    requires = {
      { 'hrsh7th/vim-vsnip' },
      { 'hrsh7th/cmp-vsnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      {
        'tamago324/cmp-zsh',
        config = function()
          require('cmp_zsh').setup { zshrc = false, filetypes = { 'zsh' } }
        end,
      },
      { 'mtoohey31/cmp-fish', ft = 'fish' },
      { 'onsails/lspkind-nvim' },
    },
  }

  use {
    'lukas-reineke/lsp-format.nvim',
    config = function()
      require('lsp-format').setup { sync = true }
    end,
  }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { 'lukas-reineke/lsp-format.nvim' },
    config = function()
      local null_ls = require 'null-ls'
      null_ls.setup {
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client)
          require('lsp-format').on_attach(client)
        end,
        sources = {
          -- Dockerfile
          null_ls.builtins.diagnostics.hadolint,
          -- Fish shell
          null_ls.builtins.formatting.fish_indent,
          -- Git
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.diagnostics.gitlint,
          -- GitHub Actions
          null_ls.builtins.diagnostics.actionlint,
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
          -- Shell script
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.formatting.shfmt.with {
            condition = function(utils)
              return utils.root_has_file { '.editorconfig' }
            end,
          },
          -- Text
          null_ls.builtins.diagnostics.textlint.with {
            prefer_local = 'node_modules/.bin',
            filetypes = {
              'asciidoc',
              'html',
              'markdown',
              'rst',
              'text',
              'help',
            },
            condition = function(utils)
              return utils.root_has_file { '.textlintrc' }
            end,
          },
          -- Vim script
          null_ls.builtins.diagnostics.vint,
          -- YAML
          null_ls.builtins.diagnostics.yamllint,
          -- zsh
          null_ls.builtins.diagnostics.zsh,
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
      vim.keymap.set('n', '<Space>ff', '<Cmd>Telescope find_files<CR>', { silent = true })
      vim.keymap.set('n', '<Space>fb', '<Cmd>Telescope buffers<CR>', { silent = true })
      vim.keymap.set('n', '<Space>fr', '<Cmd>Telescope resume<CR>', { silent = true })
      vim.keymap.set('n', '<Space>fg', function()
        require('telescope.builtin').git_files { git_command = { 'git', 'ls-files', '--exclude-standard', '-co' } }
      end, { silent = true })
      vim.keymap.set('n', '<Space>fig', function()
        require('telescope.builtin').git_files { git_command = { 'git', 'ls-files', '--exclude-standard', '-coi' } }
      end, { silent = true })

      vim.keymap.set('n', '<Space>f*', '<Cmd>Telescope grep_string<CR>', { silent = true })

      vim.keymap.set('n', '<Space>fh', '<Cmd>Telescope help_tags<CR>', { silent = true })
      vim.keymap.set('n', '<Space>fcs', '<Cmd>Telescope colorscheme<CR>', { silent = true })
      vim.keymap.set('n', '<Space>fFT', '<Cmd>Telescope filetypes<CR>', { silent = true })

      vim.keymap.set('n', '<Space>f:', '<Cmd>Telescope command_history<CR>', { silent = true })

      vim.keymap.set('n', '<Space>/', '<Cmd>Telescope current_buffer_fuzzy_find<CR>', { silent = true })
      vim.keymap.set('n', '<Space>f/', '<Cmd>Telescope live_grep<CR>', { silent = true })
    end,
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'folke/trouble.nvim' },
      { 'kyazdani42/nvim-web-devicons' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
  }

  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    setup = function()
      -- Lua
      vim.keymap.set('n', '<Space>xx', '<cmd>Trouble<cr>', { silent = true })
      vim.keymap.set('n', '<Space>xw', '<cmd>Trouble workspace_diagnostics<cr>', { silent = true })
      vim.keymap.set('n', '<Space>xd', '<cmd>Trouble document_diagnostics<cr>', { silent = true })
      -- vim.keymap.set('n', '<Space>xl', '<cmd>Trouble loclist<cr>', { silent = true })
      -- vim.keymap.set('n', '<Space>xq', '<cmd>Trouble quickfix<cr>', { silent = true })
      vim.keymap.set('n', 'gR', '<cmd>Trouble lsp_references<cr>', { silent = true })
    end,
    config = function()
      require('trouble').setup {
        use_diagnostic_signs = true,
      }
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install').update {}
    end,
    config = function()
      require('nvim-treesitter.configs').setup {
        -- A list of parser names, or "all"
        ensure_installed = {
          'bash',
          'css',
          'dockerfile',
          'fish',
          'go',
          'gomod',
          'graphql',
          'html',
          'javascript',
          'json',
          'jsonc',
          'lua',
          'make',
          'rust',
          'scss',
          'toml',
          'tsx',
          'typescript',
          'vim',
          'vue',
          'yaml',
        },

        -- Install languages synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- List of parsers to ignore installing
        -- ignore_install = { 'javascript' },

        highlight = {
          -- `false` will disable the whole extension
          enable = true,

          -- list of language that will be disabled
          -- disable = { 'c', 'rust' },

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
      }
    end,
    requires = {
      { 'JoosepAlviste/nvim-ts-context-commentstring' },
    },
  }

  use {
    'nvim-treesitter/playground',
    cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
  }

  use {
    'dracula/vim',
    as = 'dracula',
    config = function()
      local augroup = vim.api.nvim_create_augroup('DraculaAutoCmd', {})
      vim.api.nvim_create_autocmd('colorscheme', {
        group = augroup,
        pattern = 'dracula',
        command = 'runtime after/plugin/dracula.vim',
      })
      vim.cmd 'colorscheme dracula'
    end,
  }
  use { 'cocopon/iceberg.vim', opt = true }
  use { 'romainl/vim-dichromatic', opt = true }
  use { 'PierreCapo/voir.vim', opt = true }
  use { 'machakann/vim-colorscheme-tatami', opt = true }
  use { 'jonathanfilip/vim-lucius', opt = true }
  use { 'junegunn/seoul256.vim', opt = true }
  use { 'joshdick/onedark.vim', opt = true }
  use { 'tomasr/molokai', opt = true }
  use {
    'altercation/vim-colors-solarized',
    opt = true,
    setup = function()
      if vim.env.SOLARIZED == nil then
        vim.g.solarized_termtrans = 0
        vim.g.solarized_termcolors = 256
      else
        vim.g.solarized_termtrans = 1
        vim.g.solarized_termcolors = 16
        vim.o.background = 'dark'
        local augroup = vim.api.nvim_create_augroup('SolarizedAutoCmd', {})
        vim.api.nvim_create_autocmd('VimEnter', {
          group = augroup,
          pattern = '*',
          nested = true,
          command = 'colorscheme solarized',
        })
      end
    end,
  }
  use { 'sainnhe/edge' }
  use { 'folke/tokyonight.nvim' }
  use { 'rebelot/kanagawa.nvim' }

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
    setup = function()
      vim.keymap.set('n', '<Space>pe', '<Plug>(partedit_start_context)', { silent = true })
    end,
    requires = { { 'Shougo/context_filetype.vim' } },
  }

  use {
    'lambdalisue/gina.vim',
    config = function()
      vim.fn['gina#custom#mapping#nmap']('status', '<C-l>', '<Cmd>e<CR>', { noremap = 1, silent = 1 })
    end,
  }

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
          changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        },
        keymaps = {},
      }
    end,
  }

  use {
    'kannokanno/previm',
    ft = { 'markdown', 'rst', 'asciidoc' },
    config = function()
      vim.cmd [[packadd open-browser.vim]]
    end,
  }

  use {
    'tyru/open-browser.vim',
    keys = '<Plug>(openbrowser-smart-search)',
    setup = function()
      vim.g.netrw_nogx = 1 -- disable netrw's gx mapping.
      vim.keymap.set({ 'n', 'x' }, 'gx', '<Plug>(openbrowser-smart-search)', {})
    end,
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        -- space_char_blankline = ' ',
        show_first_indent_level = true,
        buftype_exclude = { 'nofile', 'help', 'terminal' },
        filetype_exclude = { '' },
        show_trailing_blankline_indent = false,
        -- show_current_context = true,
        -- show_current_context_start = true,
      }
    end,
  }

  use {
    't9md/vim-quickhl',
    keys = '<Plug>(quickhl-manual-this)',
    setup = function()
      vim.keymap.set('n', '<Space>hl', '<Plug>(quickhl-manual-this)', {})
      vim.keymap.set('n', '<Space>nohl', '<Plug>(quickhl-manual-reset)', {})
    end,
  }

  use {
    'kassio/neoterm',
    cmd = 'Tnew',
    setup = function()
      vim.keymap.set('n', '<Space>nl', '<Cmd>rightbelow vertical Tnew<CR>', {})
      vim.keymap.set('n', '<Space>nh', '<Cmd>vertical Tnew<CR>', {})
      vim.keymap.set('n', '<Space>nn', '<Plug>(neoterm-repl-send-line)', {})
      vim.keymap.set('x', '<Space>nn', '<Plug>(neoterm-repl-send)', {})
    end,
  }

  use {
    'numToStr/Comment.nvim',
    event = 'BufEnter',
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
    requires = {
      { 'JoosepAlviste/nvim-ts-context-commentstring' },
    },
  }

  use {
    'machakann/vim-sandwich',
    config = function()
      vim.cmd [[runtime macros/sandwich/keymap/surround.vim]]
    end,
  }

  use {
    'monaqa/dial.nvim',
    config = function()
      vim.keymap.set('n', '<C-a>', require('dial.map').inc_normal(), {})
      vim.keymap.set('n', '<C-x>', require('dial.map').dec_normal(), {})
      vim.keymap.set('v', '<C-a>', require('dial.map').inc_visual(), {})
      vim.keymap.set('v', '<C-x>', require('dial.map').dec_visual(), {})
      vim.keymap.set('v', 'g<C-a>', require('dial.map').inc_gvisual(), {})
      vim.keymap.set('v', 'g<C-x>', require('dial.map').dec_gvisual(), {})
    end,
  }

  use {
    'liuchengxu/vista.vim',
    cmd = 'Vista',
    setup = function()
      vim.g.vista_default_executive = 'nvim_lsp'
    end,
  }

  use {
    'kyazdani42/nvim-tree.lua',
    cmd = 'NvimTreeToggle',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function()
      require('nvim-tree').setup {}
    end,
  }

  -- use {
  --   'cohama/lexima.vim',
  --   event = 'InsertEnter',
  --   setup = function()
  --     vim.g.lexima_ctrlh_as_backspace = 1
  --   end,
  --   config = function()
  --     vim.keymap.set('i', 'jj', '<Esc>', { remap = false })
  --   end,
  -- }

  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {
        map_c_h = true,
      }
    end,
  }

  use {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  }

  use {
    'AndrewRadev/linediff.vim',
    cmd = 'Linediff',
    setup = function()
      vim.g.linediff_modify_statusline = 0
      vim.g.linediff_first_buffer_command = 'topleft new'
      vim.g.linediff_second_buffer_command = 'vertical new'
      local augroup = vim.api.nvim_create_augroup('LinediffAutoCmd', {})
      vim.api.nvim_create_autocmd('User', {
        group = augroup,
        pattern = 'LinediffBufferReady',
        callback = function()
          vim.keymap.set('n', 'q', '<Cmd>LinediffReset<CR>', { buffer = true })
        end,
      })
    end,
  }

  use { 'norcalli/nvim-colorizer.lua', disable = not vim.o.termguicolors, cmd = 'ColorizerToggle' }

  use {
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup()
    end,
  }

  use { 'folke/twilight.nvim', cmd = 'Twilight' }

  use {
    'mattn/vim-sonictemplate',
    event = 'CmdlineEnter',
    setup = function()
      vim.g.loaded_sonictemplate_vim = true
    end,
    config = function()
      vim.api.nvim_create_user_command(
        'Template',
        [=[call sonictemplate#apply(<f-args>, "n")]=],
        { nargs = 1, complete = 'customlist,sonictemplate#complete' }
      )
    end,
  }

  use 'DanilaMihailov/beacon.nvim'
end

return packer.startup {
  function()
    init()
  end,
  config = {
    display = {
      -- open_fn = require('packer.util').float,
      open_cmd = [=[tabnew \[packer\]]=],
    },
    autoremove = true,
  },
}
