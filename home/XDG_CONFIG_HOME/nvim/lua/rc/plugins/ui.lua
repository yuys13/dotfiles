---@type LazySpec[]
local spec = {
  { 'nvim-tree/nvim-web-devicons' },

  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.showmode = false
    end,
    config = function()
      vim.o.laststatus = 2

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
          theme = 'dracula',
          icons_enabled = false,
          section_separators = '',
          component_separators = '',
        },
        sections = {
          lualine_a = { eskk_mode, 'mode' },
        },
      }
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('MyLualineAutocmd', { clear = true }),
        pattern = '*',
        callback = function(arg)
          local theme = 'auto'
          if arg.match == 'default' then
            theme = 'dracula'
          end
          require('lualine').setup {
            options = {
              theme = theme,
            },
          }
        end,
      })
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
        indent = {
          char = '│', -- default value of v2
        },
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
    'Bekaboo/dropbar.nvim',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      require('dropbar').setup {
        bar = {
          sources = function(buf, _)
            local sources = require 'dropbar.sources'
            local utils = require 'dropbar.utils'
            if vim.bo[buf].ft == 'markdown' then
              return {
                sources.path,
                sources.markdown,
              }
            end
            if vim.bo[buf].buftype == 'terminal' then
              return {
                sources.terminal,
              }
            end
            return {
              -- sources.path,
              utils.source.fallback {
                sources.lsp,
                sources.treesitter,
              },
            }
          end,
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
