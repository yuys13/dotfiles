---@type LazySpec[]
local spec = {
  { 'yuys13/hackshark.nvim' },

  {
    'dracula/vim',
    name = 'dracula',
  },

  { 'cocopon/iceberg.vim' },

  { 'romainl/vim-dichromatic' },

  { 'PierreCapo/voir.vim' },

  { 'machakann/vim-colorscheme-tatami' },

  { 'jonathanfilip/vim-lucius' },

  { 'junegunn/seoul256.vim' },

  { 'joshdick/onedark.vim' },

  { 'tomasr/molokai' },

  { 'sainnhe/edge' },

  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  { 'rebelot/kanagawa.nvim' },

  {
    'miikanissi/modus-themes.nvim',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('modus-themes').setup {
        variant = 'deuteranopia',
      }
    end,
  },
}

return spec
