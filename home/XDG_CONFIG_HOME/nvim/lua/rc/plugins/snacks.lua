---@type LazySpec[]
local spec = {
  {
    'folke/snacks.nvim',
    lazy = false,
    keys = {
      -- stylua: ignore start
      { '<Space><Space>', function() Snacks.picker() end, desc = 'Picker' },
      { '<Space>fh', function() Snacks.picker.help() end, desc = 'Help' },
      { '<Space>ff', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
      { '<Space>f/', function() Snacks.picker.grep() end, desc = 'Grep' },
      { '<Space>f:', function() Snacks.picker.command_history() end, desc = 'Command History' },
      -- { "<Space>fn", function() Snacks.picker.notifications() end, desc = "Notification History" },
      -- { "<Space>fe", function() Snacks.explorer() end, desc = "File Explorer" },
      { '<Space>fr', function() Snacks.picker.resume() end, desc = 'Resume' },
      -- find
      { '<Space>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
      -- { "<Space>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      -- { "<Space>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { '<Space>fg', function() Snacks.picker.git_files({untracked = true}) end, desc = 'Find Git Files' },
      -- { "<Space>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { '<Space>fr', function() Snacks.picker.recent() end, desc = 'Recent' },
      -- Grep
      { '<Space>/', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
      -- stylua: ignore stop
    },
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
