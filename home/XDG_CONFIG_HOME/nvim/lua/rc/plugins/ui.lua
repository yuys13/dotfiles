---@type LazySpec[]
local spec = {
  { 'nvim-tree/nvim-web-devicons' },

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
          -- return vim.g['eskk#statusline_mode_strings']['ascii']
          return ''
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
    'nvim-zh/colorful-winsep.nvim',
    cond = false,
    config = true,
    event = { 'WinNew' },
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
        signs_staged_enable = false,
        attach_to_untracked = true,
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
      require('ibl').setup {
        -- indent = {
        --   char = '│', -- default value of v2
        -- },
        scope = {
          enabled = false,
        },
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
    'utilyre/barbecue.nvim',
    event = 'BufReadPre',
    name = 'barbecue',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
    },
    config = function()
      require('barbecue').setup {
        show_dirname = false,
        show_basename = false,
        show_navic = true,
      }
    end,
  },

  {
    'b0o/incline.nvim',
    cond = false,
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
    config = function()
      require('nvim-navic').setup {
        lsp = {
          auto_attach = true,
        },
      }
    end,
  },

  {
    'norcalli/nvim-colorizer.lua',
    cmd = 'ColorizerToggle',
  },

  {
    'DanilaMihailov/beacon.nvim',
    event = { 'CursorMoved' },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('beacon').setup {
        speed = 1,
      }
    end,
  },

  { 'delphinus/auto-cursorline.nvim', event = 'VeryLazy', config = true, cond = false },
}

return spec
