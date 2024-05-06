---@type LazySpec[]
local spec = {
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
      map('n', '<M-x>', '<Cmd>Telescope builtin<CR>', { desc = 'Telescope builtin' })
      map('n', '<Space><Space>', '<Cmd>Telescope builtin<CR>', { desc = 'Telescope builtin' })
      map('n', '<Space>ft', '<Cmd>Telescope file_browser<CR>', { desc = 'Telescope file_browser' })
    end,
    config = function()
      require('telescope').setup {
        defaults = {
          layout_config = {
            horizontal = {
              prompt_position = 'top',
            },
          },
          sorting_strategy = 'ascending',
          mappings = {
            i = {
              ['?'] = 'which_key',
              ['<C-j>'] = false,
              -- ['<C-j>'] = 'move_selection_next',
              -- ['<C-k>'] = 'move_selection_previous',
            },
            n = {
              t = 'select_tab',
            },
          },
        },
        pickers = {},
        extensions = {
          file_browser = {
            theme = 'ivy',
            hijack_netrw = false,
            mappings = {
              ['i'] = {
                -- your custom insert mode mappings
              },
              ['n'] = {
                -- your custom normal mode mappings
              },
            },
          },
        },
      }
      require('telescope').load_extension 'file_browser'
    end,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
    },
  },
}

return spec
