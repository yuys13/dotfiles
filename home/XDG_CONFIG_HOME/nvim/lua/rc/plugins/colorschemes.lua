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

  { 'cocopon/iceberg.vim' },

  { 'romainl/vim-dichromatic' },

  { 'PierreCapo/voir.vim' },

  { 'machakann/vim-colorscheme-tatami' },

  { 'jonathanfilip/vim-lucius' },

  { 'junegunn/seoul256.vim' },

  { 'joshdick/onedark.vim' },

  { 'tomasr/molokai' },

  { 'sainnhe/edge' },

  { 'folke/tokyonight.nvim' },

  { 'rebelot/kanagawa.nvim' },
}