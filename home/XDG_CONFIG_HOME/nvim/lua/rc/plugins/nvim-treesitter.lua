---@type LazySpec[]
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      local ts = require 'nvim-treesitter'
      -- ts.install 'unstable'

      local filetypes = {}
      for _, lang in ipairs(ts.get_available(2)) do
        for _, filetype in ipairs(vim.treesitter.language.get_filetypes(lang)) do
          table.insert(filetypes, filetype)
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function(args)
          -- size check
          local max_filesize = 512 * 1024 -- 512[KB]
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
          if ok and stats and stats.size > max_filesize then
            return
          end

          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    keys = {
      {
        'af',
        mode = { 'x', 'o' },
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
        end,
      },
      {
        'if',
        mode = { 'x', 'o' },
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
        end,
      },
    },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          selection_modes = {
            ['@function.outer'] = 'V',
          },
          include_surrounding_whitespace = false,
        },
      }
    end,
  },

  {
    'andymass/vim-matchup',
    lazy = false,
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
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
