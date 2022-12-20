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
    event = { 'BufReadPre', 'BufNewFile' },
    setup = function()
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.silent = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      local augroup = vim.api.nvim_create_augroup('LazyDiagMap', {})
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        group = augroup,
        once = true,
        callback = function()
          map('n', '<space>e', vim.diagnostic.open_float, { desc = 'LSP diagnostic open_float' })
          map('n', '[d', vim.diagnostic.goto_prev, { desc = 'LSP diagnostic goto_prev' })
          map('n', ']d', vim.diagnostic.goto_next, { desc = 'LSP diagnostic goto_next' })
          map('n', '<space>ql', vim.diagnostic.setqflist, { desc = 'LSP diagnostic setqflist' })
          map('n', '<space>ll', vim.diagnostic.setloclist, { desc = 'LSP diagnostic setloclist' })
        end,
      })
    end,
    config = function()
      require 'rc.lspconfig'
    end,
    requires = {
      { 'folke/neodev.nvim', module = 'neodev' },
      { 'b0o/SchemaStore.nvim' },
    },
  }

  use {
    'williamboman/mason.nvim',
    event = 'CmdlineEnter',
    module = 'mason',
    config = function()
      require('mason').setup()
    end,
  }

  use {
    'williamboman/mason-lspconfig.nvim',
    module = 'mason-lspconfig',
  }

  use {
    'ray-x/lsp_signature.nvim',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      require('lsp_signature').setup()
    end,
  }

  use {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
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
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function()
      require 'rc.nvim-cmp'
      if vim.g.colors_name == 'dracula' then
        vim.cmd 'runtime after/plugin/dracula.vim'
      end
    end,
    requires = {
      { 'hrsh7th/vim-vsnip', event = 'InsertEnter' },
      { 'hrsh7th/cmp-vsnip', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp', module = 'cmp_nvim_lsp' },
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
      {
        'tamago324/cmp-zsh',
        disable = vim.fn.executable 'zsh' == 0,
        after = 'nvim-cmp',
        config = function()
          require('cmp_zsh').setup { zshrc = false, filetypes = { 'zsh' } }
        end,
      },
      {
        'mtoohey31/cmp-fish',
        disable = vim.fn.executable 'fish' == 0,
        after = 'nvim-cmp',
      },
      { 'onsails/lspkind-nvim' },
    },
  }

  use {
    'lukas-reineke/lsp-format.nvim',
    module = 'lsp-format',
    config = function()
      require('lsp-format').setup { sync = true }
    end,
  }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      local null_ls = require 'null-ls'
      null_ls.setup {
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          require('lsp-format').on_attach(client)
          vim.keymap.set(
            'n',
            '<Space>ca',
            vim.lsp.buf.code_action,
            { buffer = bufnr, silent = true, desc = 'LSP code_action' }
          )
          vim.keymap.set('n', '<space>lf', vim.lsp.buf.format, { buffer = bufnr, silent = true, desc = 'LSP format' })
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
          -- null_ls.builtins.formatting.gofmt.with {
          --   extra_args = { '-s' },
          -- },
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
    cmd = 'Telescope',
    module = { 'telescope', 'telescope.builtin' },
    setup = function()
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.silent = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      map('n', '<Space>ff', '<Cmd>Telescope find_files<CR>', { desc = 'Telescope find_files' })
      map('n', '<Space>fb', '<Cmd>Telescope buffers<CR>', { desc = 'Telescope buffers' })
      map('n', '<Space>fr', '<Cmd>Telescope resume<CR>', { desc = 'Telescope resume' })
      map('n', '<Space>fg', function()
        require('telescope.builtin').git_files { git_command = { 'git', 'ls-files', '--exclude-standard', '-co' } }
      end, { desc = 'Telescope git_files' })
      map('n', '<Space>fig', function()
        require('telescope.builtin').git_files { git_command = { 'git', 'ls-files', '--exclude-standard', '-coi' } }
      end, { desc = 'Telescope git_files ignore only' })

      map('n', '<Space>f*', '<Cmd>Telescope grep_string<CR>', { desc = 'Telescope grep_string' })

      map('n', '<Space>fk', '<Cmd>Telescope keymaps<CR>', { desc = 'Telescope keymaps' })
      map('n', '<Space>fh', '<Cmd>Telescope help_tags<CR>', { desc = 'Telescope help_tags' })
      map('n', '<Space>fcs', '<Cmd>Telescope colorscheme<CR>', { desc = 'Telescope colorscheme' })
      map('n', '<Space>fFT', '<Cmd>Telescope filetypes<CR>', { desc = 'Telescope filetypes' })

      map('n', '<Space>f:', '<Cmd>Telescope command_history<CR>', { desc = 'Telescope command_history' })

      map('n', '<Space>/', '<Cmd>Telescope current_buffer_fuzzy_find<CR>', { desc = 'Telescope current_buffer_ff' })
      map('n', '<Space>f/', '<Cmd>Telescope live_grep<CR>', { desc = 'Telescope live_grep' })
      map('n', '<Space><Space>', '<Cmd>Telescope builtin<CR>', { desc = 'Telescope builtin' })
    end,
    config = function()
      require('telescope').setup {
        defaults = {
          layout_strategies = 'horizontal',
          layout_config = {
            horizontal = {
              prompt_position = 'top',
            },
          },
          sorting_strategy = 'ascending',
          mappings = {
            i = {
              ['?'] = 'which_key',
              ['<C-j>'] = 'move_selection_next',
              ['<C-k>'] = 'move_selection_previous',
            },
            n = {
              t = 'select_tab',
            },
          },
        },
        pickers = {},
        extensions = {},
      }
    end,
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'kyazdani42/nvim-web-devicons' },
    },
  }

  use {
    'stevearc/dressing.nvim',
    event = { 'BufRead', 'BufNewFile', 'CmdlineEnter' },
    config = function()
      require('dressing').setup {}
    end,
  }

  use {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    requires = 'kyazdani42/nvim-web-devicons',
    setup = function()
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.silent = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Lua
      map('n', '<Space>xx', '<cmd>Trouble<cr>', { desc = 'Trouble' })
      map('n', '<Space>xw', '<cmd>Trouble workspace_diagnostics<cr>', { desc = 'Trouble workspace_diagnostics' })
      map('n', '<Space>xd', '<cmd>Trouble document_diagnostics<cr>', { desc = 'Trouble document_diagnostics' })
      -- map('n', '<Space>xl', '<cmd>Trouble loclist<cr>', { desc = 'Trouble loclist' })
      -- map('n', '<Space>xq', '<cmd>Trouble quickfix<cr>', { desc = 'Trouble quickfix' })
      map('n', 'gR', '<cmd>Trouble lsp_references<cr>', { desc = 'Trouble lsp_references' })
    end,
    config = function()
      require('trouble').setup {
        use_diagnostic_signs = true,
      }
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufRead', 'BufNewFile' },
    run = function()
      require('nvim-treesitter.install').update {}()
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

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = vim.fn.executable 'tree-sitter' == 1,

        -- List of parsers to ignore installing (for "all")
        -- ignore_install = { 'javascript' },

        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

        highlight = {
          -- `false` will disable the whole extension
          enable = true,

          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          -- list of language that will be disabled
          -- disable = { 'c', 'rust' },
          -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
          -- disable = function(lang, buf)
          --   local max_filesize = 100 * 1024 -- 100 KB
          --   local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          --   if ok and stats and stats.size > max_filesize then
          --     return true
          --   end
          -- end,
          disable = function(lang, buf)
            local max_filesize = 512 * 1024 -- 512 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
            if not pcall(function()
              vim.treesitter.get_parser(0, lang):parse()
            end) then
              return true
            end

            if not pcall(function()
              vim.treesitter.get_query(lang, 'highlights')
            end) then
              return true
            end

            return false
          end,

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
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
            selection_modes = {
              ['@function.outer'] = 'V',
              ['@class.outer'] = 'V',
              ['@class.inner'] = 'V',
            },
          },
        },
      }
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  use {
    'nvim-treesitter/nvim-treesitter-context',
    after = 'nvim-treesitter',
    config = function()
      require('treesitter-context').setup {}
    end,
  }

  use {
    'nvim-treesitter/playground',
    cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
  }

  use {
    'mfussenegger/nvim-dap',
    keys = '<Plug>(dap)',
    setup = function()
      vim.keymap.set('n', '<Plug>(dap)', '<Nop>', { silent = true })
      vim.keymap.set('n', '<Space>d', '<Plug>(dap)', { silent = true })
    end,
    config = function()
      local dap = require 'dap'
      vim.keymap.set('n', '<Plug>(dap)b', require('dap').toggle_breakpoint)
      vim.keymap.set('n', '<Plug>(dap)c', require('dap').continue)
      vim.keymap.set('n', '<Plug>(dap)j', require('dap').step_over)
      vim.keymap.set('n', '<Plug>(dap)k', require('dap').step_back)
      vim.keymap.set('n', '<Plug>(dap)h', require('dap').step_out)
      vim.keymap.set('n', '<Plug>(dap)l', require('dap').step_into)
      dap.adapters.bashdb = {
        type = 'executable',
        command = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
        name = 'bashdb',
      }
      dap.configurations.sh = {
        {
          type = 'bashdb',
          request = 'launch',
          name = 'Launch file',
          showDebugOutput = true,
          pathBashdb = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
          pathBashdbLib = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
          trace = true,
          file = '${file}',
          program = '${file}',
          cwd = '${workspaceFolder}',
          pathCat = 'cat',
          pathBash = vim.fn.exepath 'bash',
          pathMkfifo = 'mkfifo',
          pathPkill = 'pkill',
          args = {},
          env = {},
          terminalKind = 'integrated',
        },
      }
    end,
  }

  use {
    'rcarriga/nvim-dap-ui',
    after = 'nvim-dap',
    requires = { 'mfussenegger/nvim-dap' },
    config = function()
      vim.keymap.set('n', '<Plug>(dap)d', require('dapui').toggle)
      require('dapui').setup {}
    end,
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
    event = { 'BufRead', 'BufNewFile', 'CursorHold' },
    setup = function()
      vim.o.laststatus = 0
      vim.o.showmode = false
    end,
    config = function()
      vim.o.laststatus = 2
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
    keys = '<Plug>(partedit_start_context)',
    cmd = { 'PartEdit', 'PartEditContext' },
    setup = function()
      vim.keymap.set('n', '<Space>pe', '<Plug>(partedit_start_context)', { silent = true })
    end,
    requires = { { 'Shougo/context_filetype.vim' } },
  }

  use {
    'lambdalisue/gina.vim',
    cmd = 'Gina',
    config = function()
      vim.fn['gina#custom#mapping#nmap']('status', '<C-l>', '<Cmd>e<CR>', { noremap = 1, silent = 1 })
    end,
  }

  use {
    'lewis6991/gitsigns.nvim',
    event = { 'BufRead', 'BufNewFile' },
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
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = 'next hunk' })

          map('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = 'prev hunk' })
        end,
      }
    end,
  }

  use {
    'kannokanno/previm',
    ft = { 'markdown', 'rst', 'asciidoc' },
    after = 'open-browser.vim',
  }

  use {
    'tyru/open-browser.vim',
    ft = { 'markdown', 'rst', 'asciidoc' },
    keys = '<Plug>(openbrowser-smart-search)',
    setup = function()
      vim.g.netrw_nogx = 1 -- disable netrw's gx mapping.
      vim.keymap.set({ 'n', 'x' }, 'gx', '<Plug>(openbrowser-smart-search)', {})
    end,
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufRead', 'BufNewFile' },
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
    -- event = { 'BufRead', 'BufNewFile' },
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
    after = 'nvim-treesitter',
    requires = {
      { 'JoosepAlviste/nvim-ts-context-commentstring', module = 'ts_context_commentstring.integrations.comment_nvim' },
    },
  }

  use {
    'machakann/vim-sandwich',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      vim.cmd [[runtime macros/sandwich/keymap/surround.vim]]
      vim.fn['operator#sandwich#set']('add', 'char', 'skip_space', 1)
    end,
  }

  use {
    'monaqa/dial.nvim',
    keys = {
      '<Plug>(dial-increment)',
      '<Plug>(dial-decrement)',
      '<Plug>(vimrc-dial-increment)',
      '<Plug>(vimrc-dial-decrement)',
    },
    module = 'dial.map',
    setup = function()
      vim.keymap.set({ 'n', 'v' }, '<C-a>', '<Plug>(dial-increment)', {})
      vim.keymap.set({ 'n', 'v' }, '<C-x>', '<Plug>(dial-decrement)', {})
      vim.keymap.set('v', 'g<C-a>', '<Plug>(vimrc-dial-increment)', {})
      vim.keymap.set('v', 'g<C-x>', '<Plug>(vimrc-dial-decrement)', {})
    end,
    config = function()
      vim.keymap.set('v', '<Plug>(vimrc-dial-increment)', require('dial.map').inc_gvisual(), {})
      vim.keymap.set('v', '<Plug>(vimrc-dial-decrement)', require('dial.map').dec_gvisual(), {})
    end,
  }

  use { 'kevinhwang91/nvim-bqf', ft = 'qf' }

  use {
    'stevearc/aerial.nvim',
    cmd = 'AerialToggle',
    config = function()
      require('aerial').setup {
        backends = { 'lsp', 'treesitter', 'markdown', 'man' },
        lazy_load = true,
        layout = {
          win_opts = { winblend = 30 },
        },
        -- show_guides = true,
        float = {
          relative = 'win',
          override = function(conf, source_winid)
            conf.col = vim.fn.winwidth(source_winid)
            conf.row = 0
            vim.pretty_print(conf)
            return conf
          end,
        },
      }
      local ok, telescope = pcall(require, 'telescope')
      if ok then
        telescope.load_extension 'aerial'
      end
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

  use {
    'cohama/lexima.vim',
    event = 'InsertEnter',
    setup = function()
      vim.g.lexima_ctrlh_as_backspace = 1
    end,
    config = function()
      vim.keymap.set('i', 'jj', '<Esc>', { remap = true })
    end,
  }

  use {
    'windwp/nvim-ts-autotag',
    -- event = 'InsertEnter',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
    after = 'nvim-treesitter',
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

  use { 'norcalli/nvim-colorizer.lua', cond = vim.o.termguicolors, cmd = 'ColorizerToggle' }

  use {
    'petertriho/nvim-scrollbar',
    -- event = { 'BufRead', 'BufNewFile' },
    after = 'gitsigns.nvim',
    config = function()
      require('scrollbar').setup {
        handlers = {
          cursor = false,
        },
      }
      require('scrollbar.handlers.gitsigns').setup()
    end,
  }

  use {
    'mattn/vim-sonictemplate',
    cmd = 'Template',
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

  use {
    'tyru/capture.vim',
    cmd = 'Capture',
  }

  use { 'DanilaMihailov/beacon.nvim', event = { 'BufRead', 'BufNewFile' } }

  use { 'Eandrju/cellular-automaton.nvim', cmd = 'CellularAutomaton' }
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
