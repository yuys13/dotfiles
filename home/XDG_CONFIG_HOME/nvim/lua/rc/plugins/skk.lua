---@type LazySpec[]
local spec = {
  {
    'vim-skk/eskk.vim',
    keys = { { '<C-j>', '<Plug>(eskk:enable)', mode = { 'i', 'c' } } },
    init = function()
      vim.g['eskk#no_default_mappings'] = 1
    end,
    config = function()
      local eskk_base_dir = vim.fn.stdpath 'data' .. '/eskk'
      local jisyo = eskk_base_dir .. '/.skk-jisyo'
      local large_jisyo = eskk_base_dir .. '/SKK-JISYO.L'

      -- directory
      vim.g['eskk#directory'] = eskk_base_dir

      -- dictionary
      vim.g['eskk#dictionary'] = jisyo
      vim.g['eskk#large_dictionary'] = {
        path = large_jisyo,
        sorted = 1,
        encoding = 'euc-jp',
      }

      -- settings
      vim.g['eskk#egg_like_newline'] = 1

      -- respect ddskk
      vim.g['eskk#statusline_mode_strings'] = {
        hira = '--かな:',
        kata = '--カナ:',
        ascii = '--SKK::',
        zenei = '--全英:',
        hankata = '--ｶﾀｶﾅ:',
        abbrev = '--aあ::',
      }

      -- don't use ascii mode
      vim.api.nvim_create_autocmd('User', {
        pattern = 'eskk-enable-post',
        group = vim.api.nvim_create_augroup('vimrc-eskk-augroup', {}),
        callback = function(args)
          vim.keymap.set('l', 'l', '<Plug>(eskk:disable)', { buffer = args.buf })
          vim.keymap.set('l', 'zl', '→', { buffer = args.buf })
        end,
      })

      -- auto get jisyo
      if vim.fn.filereadable(large_jisyo) == 0 then
        -- get jisyo
        local ok = require('skk-develop').skk_get()

        if ok then
          if vim.fn.isdirectory(eskk_base_dir) == 0 then
            vim.fn.mkdir(eskk_base_dir, 'p')
          end
          if vim.fn.executable 'skkdic-expr2' == 1 then
            -- merge jisyo
            local use_jisyo = {
              'SKK-JISYO.L',
              'SKK-JISYO.jinmei',
              'SKK-JISYO.geo',
              'SKK-JISYO.station',
              'SKK-JISYO.propernoun',
              'SKK-JISYO.zipcode',
            }

            local arg_str = table.concat(use_jisyo, ' + ')

            local arg = {}
            for word in arg_str:gmatch '%S+' do
              table.insert(arg, word)
            end

            local Job = require 'plenary.job'

            local result = Job:new({
              command = 'skkdic-expr2',
              args = arg,
              cwd = vim.fn.stdpath 'data' .. '/skk-get-jisyo',
            }):sync()

            vim.fn.writefile(result, eskk_base_dir .. '/SKK-JISYO.L')
          else
            -- fallback to SKK-JISYO.L
            os.rename(vim.fn.stdpath 'data' .. '/skk-get-jisyo/SKK-JISYO.L', large_jisyo)
          end
        end
      end
    end,
  },

  { 'vim-skk/skkdict.vim', lazy = false },

  { 'yuys13/skk-develop.nvim' },
}

return spec
