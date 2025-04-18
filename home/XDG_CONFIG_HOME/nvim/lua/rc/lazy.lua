-- bootstrap
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

-- load lazy
require('lazy').setup('rc.plugins', {
  defaults = { lazy = true },
  concurrency = 16,
  pkg = {
    enabled = false,
  },
  rocks = {
    enabled = false,
  },
  dev = {
    path = '~/src/github.com/yuys13',
  },
  ui = {
    border = 'single',
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        -- 'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
