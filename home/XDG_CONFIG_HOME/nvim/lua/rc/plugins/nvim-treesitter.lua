---@type LazySpec[]
local spec = {
  {
    'nvim-treesitter/nvim-treesitter',
    cmd = { 'TSInstall', 'TSUpdate' },
    event = { 'BufRead', 'BufNewFile' },
    build = ':TSUpdate',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        -- A list of parser names, or "all"
        ensure_installed = 'all',
        -- ensure_installed = {
        --   'bash',
        --   'css',
        --   'dockerfile',
        --   'fish',
        --   'go',
        --   'gomod',
        --   'graphql',
        --   'html',
        --   'javascript',
        --   'json',
        --   'jsonc',
        --   'lua',
        --   'make',
        --   'rust',
        --   'scss',
        --   'toml',
        --   'tsx',
        --   'typescript',
        --   'vim',
        --   'vue',
        --   'yaml',
        -- },

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

            local query
            ok, query = pcall(vim.treesitter.query.get, lang, 'highlights')
            if not ok or query == nil then
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
        indent = {
          enable = true,
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
        matchup = {
          enable = true,
        },
      }
    end,
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      {
        'andymass/vim-matchup',
        init = function()
          vim.g.matchup_matchparen_offscreen = { method = 'popup' }
        end,
      },
    },
  },

  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gc', mode = { 'n', 'x' } },
      { 'gb', mode = { 'n', 'x' } },
      { 'gcc', mode = 'n' },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
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
    'andersevenrud/nvim_context_vt',
    cmd = 'NvimContextVtToggle',
    config = function()
      require('nvim_context_vt').setup {
        enabled = false,
      }
    end,
  },

  {
    'Wansmer/treesj',
    cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin' },
    config = function()
      require('treesj').setup {
        use_default_keymaps = false,
      }
    end,
  },
}

return spec
