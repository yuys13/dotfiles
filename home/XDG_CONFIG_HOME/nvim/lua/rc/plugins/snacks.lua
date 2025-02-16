---@type LazySpec[]
local spec = {
  {
    'folke/snacks.nvim',
    lazy = false,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('snacks').setup {
        picker = { enabled = true },
        input = { enabled = true },
        styles = {
          input = {
            relative = 'cursor',
          },
        },
      }
    end,
  },
}

return spec
