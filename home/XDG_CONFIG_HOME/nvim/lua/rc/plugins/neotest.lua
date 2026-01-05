---@type LazySpec[]
return {
  {
    'nvim-neotest/neotest',
    cmd = 'Neotest',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('neotest').setup {
        adapters = {
          require 'neotest-plenary',
          require 'neotest-golang',
        },
        ---@diagnostic disable-next-line: missing-fields
        floating = {
          border = 'single',
        },
      }
    end,
  },
  { 'nvim-neotest/neotest-plenary' },
  { 'fredrikaverpil/neotest-golang' },
}
