---@type LazySpec[]
local spec = {
  {
    'mfussenegger/nvim-dap',
    keys = {
      { '<Space>d', '<Plug>(dap)' },
    },
    config = function()
      local dap = require 'dap'
      vim.keymap.set('n', '<Plug>(dap)', '<Nop>', { silent = true })
      vim.keymap.set('n', '<Plug>(dap)b', require('dap').toggle_breakpoint)
      vim.keymap.set('n', '<Plug>(dap)c', require('dap').continue)
      vim.keymap.set('n', '<Plug>(dap)j', require('dap').step_over)
      vim.keymap.set('n', '<Plug>(dap)k', require('dap').step_back)
      vim.keymap.set('n', '<Plug>(dap)h', require('dap').step_out)
      vim.keymap.set('n', '<Plug>(dap)l', require('dap').step_into)
      dap.adapters.bashdb = {
        type = 'executable',
        command = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
        name = 'bashdb',
      }
      dap.configurations.sh = {
        {
          type = 'bashdb',
          request = 'launch',
          name = 'Launch file',
          showDebugOutput = true,
          pathBashdb = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
          pathBashdbLib = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
          trace = true,
          file = '${file}',
          program = '${file}',
          cwd = '${workspaceFolder}',
          pathCat = 'cat',
          pathBash = vim.fn.exepath 'bash',
          pathMkfifo = 'mkfifo',
          pathPkill = 'pkill',
          args = {},
          env = {},
          terminalKind = 'integrated',
        },
      }
    end,
  },

  {
    'rcarriga/nvim-dap-ui',
    keys = '<Plug>(dap)d',
    config = function()
      vim.keymap.set('n', '<Plug>(dap)d', require('dapui').toggle)
      require('dapui').setup()
    end,
  },
  { 'nvim-neotest/nvim-nio' },
}

return spec
