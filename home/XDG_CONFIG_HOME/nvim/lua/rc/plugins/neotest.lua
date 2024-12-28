---@type LazySpec[]
local spec = {
  {
    'nvim-neotest/neotest',
    cmd = 'Neotest',
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-plenary',
        },
      }
    end,
  },
  { 'nvim-neotest/neotest-plenary' },
}

return spec
