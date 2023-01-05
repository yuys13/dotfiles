return {
  {
    'yuys13/hackshark.nvim',
    lazy = false,
    config = function()
      vim.cmd.colorscheme 'hackshark'
    end,
  },

  {
    'dracula/vim',
    event = 'CursorHold',
    name = 'dracula',
    config = function()
      local augroup = vim.api.nvim_create_augroup('DraculaAutoCmd', {})
      vim.api.nvim_create_autocmd('colorscheme', {
        group = augroup,
        nested = true,
        pattern = 'dracula',
        command = 'runtime after/plugin/dracula.vim',
      })
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
}
