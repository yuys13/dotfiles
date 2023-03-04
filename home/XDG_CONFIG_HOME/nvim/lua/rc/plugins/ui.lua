---@type LazySpec[]
local spec = {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function()
      vim.o.laststatus = 2
      vim.o.showmode = false
      require('lualine').setup {
        options = {
          icons_enabled = false,
          section_separators = '',
          component_separators = '',
        },
      }
    end,
  },

  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    config = function()
      require('dressing').setup {}
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '│' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
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
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
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
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
      require('bqf').enable()
    end,
  },

  {
    'petertriho/nvim-scrollbar',
    event = 'VeryLazy',
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
    'norcalli/nvim-colorizer.lua',
    cond = function()
      return vim.o.termguicolors
    end,
    cmd = 'ColorizerToggle',
  },

  { 'DanilaMihailov/beacon.nvim', event = { 'CursorMoved' } },
  { 'delphinus/auto-cursorline.nvim', event = 'VeryLazy', config = true, cond = false },
}

return spec
