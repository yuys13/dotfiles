---@type LazySpec[]
local spec = {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function()
      vim.o.laststatus = 2
      vim.o.showmode = false

      -- for eskk
      local function eskk_mode()
        if vim.g.loaded_eskk ~= 1 then
          return ''
        end

        if vim.fn.mode() ~= 'i' then
          return ''
        end
        if vim.fn['eskk#is_enabled']() == 0 then
          return vim.g['eskk#statusline_mode_strings']['ascii']
        end

        -- return vim.fn['eskk#statusline']()
        return vim.g['eskk#statusline_mode_strings'][vim.fn['eskk#get_mode']()]
      end

      require('lualine').setup {
        options = {
          icons_enabled = false,
          section_separators = '',
          component_separators = '',
        },
        sections = {
          lualine_a = { eskk_mode, 'mode' },
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
    'b0o/incline.nvim',
    event = 'LspAttach',
    config = function()
      require('incline').setup {
        render = function(props)
          return require('nvim-navic').get_location(nil, props.buf)
        end,
        window = {
          placement = {
            horizontal = 'left',
            vertical = 'top',
          },
        },
      }
    end,
  },

  {
    'SmiteshP/nvim-navic',
    event = 'LspAttach',
    opts = {
      lsp = {
        auto_attach = true,
      },
    },
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
