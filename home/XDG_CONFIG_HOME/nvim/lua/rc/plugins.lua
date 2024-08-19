vim.api.nvim_create_autocmd('User', {
  once = true,
  pattern = 'VeryLazy',
  callback = function()
    vim.api.nvim_create_user_command('LazyLoadAllPlugins', function()
      local specs = require('lazy').plugins()
      local names = {}
      for _, spec in pairs(specs) do
        -- vim.pretty_print(value)
        if spec.lazy and not spec['_'].loaded and not spec['_'].dep and not spec['_'].cond then
          table.insert(names, spec.name)
        end
      end
      require('lazy').load { plugins = names }
    end, {})
  end,
})

-- local TIMEOUT = 500
-- local n = 0
-- local timer = vim.loop.new_timer()
-- vim.on_key(function()
--   timer:start(TIMEOUT, 0, function()
--     n = n + 1
--     print(n)
--   end)
-- end)

---@type LazySpec[]
local spec = {
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('trouble').setup {}
    end,
  },

  {
    'yuys13/partedit.vim',
    keys = {
      { '<Space>pe', '<Plug>(partedit_start_context)' },
    },
    cmd = { 'PartEdit', 'PartEditContext' },
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
    'kannokanno/previm',
    ft = { 'markdown', 'rst', 'asciidoc' },
    dependencies = {
      { 'tyru/open-browser.vim' },
    },
  },

  {
    't9md/vim-quickhl',
    keys = {
      { '<Space>hl', '<Plug>(quickhl-manual-this)' },
    },
    config = function()
      -- vim.keymap.set('n', '<Space>hl', '<Plug>(quickhl-manual-this)', {})
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
    'machakann/vim-sandwich',
    keys = { 'y', 'd', 'c', { 'S', mode = 'x' } },
    init = function()
      vim.g.sandwich_no_default_key_mappings = 1
    end,
    config = function()
      vim.cmd [[runtime macros/sandwich/keymap/surround.vim]]
      vim.fn['operator#sandwich#set']('add', 'char', 'skip_space', 1)
    end,
  },

  {
    'monaqa/dial.nvim',
    keys = {
      { '<C-a>', '<Plug>(dial-increment)', mode = { 'n', 'v' }, desc = 'dial increment' },
      { '<C-x>', '<Plug>(dial-decrement)', mode = { 'n', 'v' }, desc = 'dial decrement' },
      { 'g<C-a>', mode = 'v' },
      { 'g<C-x>', mode = 'v' },
    },
    config = function()
      vim.keymap.set('v', 'g<C-a>', function()
        require('dial.map').manipulate('increment', 'gvisual')
      end, { desc = 'dial increment gvisual' })
      vim.keymap.set('v', 'g<C-x>', function()
        require('dial.map').manipulate('decrement', 'gvisual')
      end, { desc = 'dial decrement gvisual' })
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
    'nvim-tree/nvim-tree.lua',
    cmd = 'NvimTreeToggle',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icon
    },
    config = function()
      require('nvim-tree').setup {
        hijack_netrw = false,
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      }
    end,
  },

  {
    'stevearc/oil.nvim',
    cmd = 'Oil',
    config = function()
      require('oil').setup {
        default_file_explorer = false,
      }
    end,
  },

  {
    'cohama/lexima.vim',
    cond = false,
    event = 'InsertEnter',
    init = function()
      vim.g.lexima_ctrlh_as_backspace = 1
      vim.g.lexima_enable_space_rules = 0
    end,
    config = function()
      vim.keymap.set('i', 'jj', '<Esc>', { remap = true })
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {
        break_undo = false,
        map_c_h = true,
      }
    end,
  },

  { 'itchyny/vim-qfedit', ft = 'qf' },

  { 'thinca/vim-qfreplace', ft = 'qf' },

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
    'mattn/vim-sonictemplate',
    cmd = 'Template',
    init = function()
      vim.g.sonictemplate_key = ''
      vim.g.sonictemplate_intelligent_key = ''
      vim.g.sonictemplate_postfix_key = ''
    end,
  },

  { 'tyru/capture.vim', cmd = 'Capture' },

  { 'Eandrju/cellular-automaton.nvim', cmd = 'CellularAutomaton' },

  {
    '4513ECHO/nvim-keycastr',
    cmd = 'KeycastrToggle',
    config = function()
      local config = {
        win_config = {
          border = 'single',
        },
      }

      local keycastr = require 'keycastr'
      keycastr.config.set(config)

      local state = false
      vim.api.nvim_create_user_command('KeycastrToggle', function()
        if state then
          keycastr.disable()
          state = false
        else
          keycastr.enable()
          state = true
        end
      end, {})
    end,
  },
}

return spec
