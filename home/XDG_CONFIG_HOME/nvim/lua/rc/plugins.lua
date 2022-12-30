return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    init = function()
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
    dependencies = {
      { 'folke/neodev.nvim' },
      { 'b0o/SchemaStore.nvim' },
    },
  },

  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    config = function()
      require('mason').setup()
    end,
  },

  { 'williamboman/mason-lspconfig.nvim' },

  {
    'ray-x/lsp_signature.nvim',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      require('lsp_signature').setup()
    end,
  },

  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    config = function()
      require('fidget').setup {
        fmt = {
          stack_upwards = false,
        },
      }
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function()
      require 'rc.nvim-cmp'
      if vim.g.colors_name == 'dracula' then
        vim.cmd 'runtime after/plugin/dracula.vim'
      end
    end,
    dependencies = {
      { 'hrsh7th/vim-vsnip' },
      { 'hrsh7th/cmp-vsnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      {
        'tamago324/cmp-zsh',
        enabled = vim.fn.executable 'zsh' == 1,
        config = function()
          require('cmp_zsh').setup { zshrc = false, filetypes = { 'zsh' } }
        end,
      },
      {
        'mtoohey31/cmp-fish',
        enabled = vim.fn.executable 'fish' == 1,
      },
      { 'onsails/lspkind-nvim' },
    },
  },

  {
    'lukas-reineke/lsp-format.nvim',
    config = function()
      require('lsp-format').setup { sync = true }
    end,
  },

  {
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
  },

  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    init = function()
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
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'kyazdani42/nvim-web-devicons' },
    },
  },

  {
    'stevearc/dressing.nvim',
    event = { 'BufRead', 'BufNewFile', 'CmdlineEnter' },
    config = function()
      require('dressing').setup {}
    end,
  },

  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    dependencies = 'kyazdani42/nvim-web-devicons',
    init = function()
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
  },

  {
    'nvim-treesitter/nvim-treesitter',
    cmd = { 'TSInstall', 'TSUpdate' },
    event = { 'BufRead', 'BufNewFile' },
    build = function()
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
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
          require('treesitter-context').setup {}
        end,
      },
    },
  },

  {
    'nvim-treesitter/playground',
    cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
  },

  {
    'mfussenegger/nvim-dap',
    keys = '<Plug>(dap)',
    init = function()
      vim.keymap.set('n', '<Space>d', '<Plug>(dap)', { silent = true })
    end,
    config = function()
      local dap = require 'dap'
      vim.keymap.set('n', '<Plug>(dap)', '<Nop>', { silent = true })
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
  },

  {
    'rcarriga/nvim-dap-ui',
    keys = '<Plug>(dap)',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      vim.keymap.set('n', '<Plug>(dap)d', require('dapui').toggle)
      require('dapui').setup {}
    end,
  },

  {
    'dracula/vim',
    event = { 'VimEnter', 'BufReadPre', 'BufNewFile' },
    name = 'dracula',
    config = function()
      local augroup = vim.api.nvim_create_augroup('DraculaAutoCmd', {})
      vim.api.nvim_create_autocmd('colorscheme', {
        group = augroup,
        nested = true,
        pattern = 'dracula',
        command = 'runtime after/plugin/dracula.vim',
      })
      vim.cmd 'colorscheme dracula'
    end,
  },
  { 'cocopon/iceberg.vim', event = 'CursorHold' },
  { 'romainl/vim-dichromatic', event = 'CursorHold' },
  { 'PierreCapo/voir.vim', event = 'CursorHold' },
  { 'machakann/vim-colorscheme-tatami', event = 'CursorHold' },
  { 'jonathanfilip/vim-lucius', event = 'CursorHold' },
  { 'junegunn/seoul256.vim', event = 'CursorHold' },
  { 'joshdick/onedark.vim', event = 'CursorHold' },
  { 'tomasr/molokai', event = 'CursorHold' },
  {
    'altercation/vim-colors-solarized',
    event = 'CursorHold',
    init = function()
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
  },
  { 'sainnhe/edge', event = 'CursorHold' },
  { 'folke/tokyonight.nvim', event = 'CursorHold' },
  { 'rebelot/kanagawa.nvim', event = 'CursorHold' },

  {
    'nvim-lualine/lualine.nvim',
    event = { 'BufRead', 'BufNewFile', 'CursorHold' },
    init = function()
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
  },

  { 'editorconfig/editorconfig-vim', lazy = false },

  {
    'yuys13/partedit.vim',
    keys = '<Plug>(partedit_start_context)',
    cmd = { 'PartEdit', 'PartEditContext' },
    init = function()
      vim.keymap.set('n', '<Space>pe', '<Plug>(partedit_start_context)', { silent = true })
    end,
    dependencies = { { 'Shougo/context_filetype.vim' } },
  },

  {
    'lambdalisue/gina.vim',
    cmd = 'Gina',
    config = function()
      vim.fn['gina#custom#mapping#nmap']('status', '<C-l>', '<Cmd>e<CR>', { noremap = 1, silent = 1 })
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufRead', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
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
  },

  {
    'kannokanno/previm',
    ft = { 'markdown', 'rst', 'asciidoc' },
  },

  {
    'tyru/open-browser.vim',
    ft = { 'markdown', 'rst', 'asciidoc' },
    keys = '<Plug>(openbrowser-smart-search)',
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw's gx mapping.
      vim.keymap.set({ 'n', 'x' }, 'gx', '<Plug>(openbrowser-smart-search)', {})
    end,
  },

  {
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
  },

  {
    't9md/vim-quickhl',
    keys = '<Plug>(quickhl-manual-this)',
    init = function()
      vim.keymap.set('n', '<Space>hl', '<Plug>(quickhl-manual-this)', {})
      vim.keymap.set('n', '<Space>nohl', '<Plug>(quickhl-manual-reset)', {})
    end,
  },

  {
    'kassio/neoterm',
    cmd = 'Tnew',
    init = function()
      vim.keymap.set('n', '<Space>nl', '<Cmd>rightbelow vertical Tnew<CR>', {})
      vim.keymap.set('n', '<Space>nh', '<Cmd>vertical Tnew<CR>', {})
      vim.keymap.set('n', '<Space>nn', '<Plug>(neoterm-repl-send-line)', {})
      vim.keymap.set('x', '<Space>nn', '<Plug>(neoterm-repl-send)', {})
    end,
  },

  {
    'numToStr/Comment.nvim',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
    dependencies = {
      { 'JoosepAlviste/nvim-ts-context-commentstring' },
    },
  },

  {
    'machakann/vim-sandwich',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      vim.cmd [[runtime macros/sandwich/keymap/surround.vim]]
      vim.fn['operator#sandwich#set']('add', 'char', 'skip_space', 1)
    end,
  },

  {
    'monaqa/dial.nvim',
    keys = {
      '<C-a>',
      '<C-x>',
      '<Plug>(vimrc-dial-increment)',
      '<Plug>(vimrc-dial-decrement)',
    },
    init = function()
      vim.keymap.set('v', 'g<C-a>', '<Plug>(vimrc-dial-increment)', {})
      vim.keymap.set('v', 'g<C-x>', '<Plug>(vimrc-dial-decrement)', {})
    end,
    config = function()
      vim.keymap.set({ 'n', 'v' }, '<C-a>', '<Plug>(dial-increment)', {})
      vim.keymap.set({ 'n', 'v' }, '<C-x>', '<Plug>(dial-decrement)', {})
      vim.keymap.set('v', '<Plug>(vimrc-dial-increment)', require('dial.map').inc_gvisual(), {})
      vim.keymap.set('v', '<Plug>(vimrc-dial-decrement)', require('dial.map').dec_gvisual(), {})
    end,
  },

  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
      require('bqf').enable()
    end,
  },

  {
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
  },

  {
    'kyazdani42/nvim-tree.lua',
    cmd = 'NvimTreeToggle',
    dependencies = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function()
      require('nvim-tree').setup {}
    end,
  },

  {
    'cohama/lexima.vim',
    event = 'InsertEnter',
    init = function()
      vim.g.lexima_ctrlh_as_backspace = 1
    end,
    config = function()
      vim.keymap.set('i', 'jj', '<Esc>', { remap = true })
    end,
  },

  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },

  {
    'AndrewRadev/linediff.vim',
    cmd = 'Linediff',
    init = function()
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
  },

  {
    'norcalli/nvim-colorizer.lua',
    cond = function()
      return vim.o.termguicolors
    end,
    cmd = 'ColorizerToggle',
  },

  {
    'petertriho/nvim-scrollbar',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      require('scrollbar').setup {
        handlers = {
          cursor = false,
        },
      }
      require('scrollbar.handlers.gitsigns').setup()
    end,
  },

  {
    'mattn/vim-sonictemplate',
    cmd = 'Template',
    init = function()
      vim.g.loaded_sonictemplate_vim = true
    end,
    config = function()
      vim.api.nvim_create_user_command(
        'Template',
        [=[call sonictemplate#apply(<f-args>, "n")]=],
        { nargs = 1, complete = 'customlist,sonictemplate#complete' }
      )
    end,
  },

  { 'tyru/capture.vim', cmd = 'Capture' },

  { 'DanilaMihailov/beacon.nvim', event = { 'BufRead', 'BufNewFile' } },

  { 'Eandrju/cellular-automaton.nvim', cmd = 'CellularAutomaton' },
}
