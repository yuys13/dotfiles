local context = nil
vim.api.nvim_create_user_command('Opilot', function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local lines

  lines = vim.api.nvim_buf_get_text(0, 0, 0, pos[1] - 1, pos[2], {})
  local prefix = table.concat(lines, '\n')
  lines = vim.api.nvim_buf_get_text(0, pos[1] - 1, pos[2], -1, -1, {})
  local suffix = table.concat(lines, '\n')

  local prompt = '<PRE>' .. prefix .. ' <SUF>' .. suffix .. ' <MID>'
  local body = vim.json.encode {
    model = 'codellama:7b-code',
    prompt = prompt,
    stream = false,
  }
  -- vim.print(body)
  ---@type Job
  local job = require('plenary.curl').post('http://localhost:11434/api/generate', {
    body = body,
    timeout = 1000 * 60 * 1,
  })
  local result = vim.fn.json_decode(job.body)
  -- vim.print(result.response)
  local hoge = string.gsub(result.response, ' <EOT>$', '')
  vim.api.nvim_buf_set_text(0, pos[1] - 1, pos[2], pos[1] - 1, pos[2], vim.split(hoge, '\n'))
end, {})

-- Stream
local function requestOllama(prompt, cb)
  require('plenary.curl').post('http://localhost:11434/api/generate', {
    body = vim.json.encode {
      model = 'mistral',
      prompt = prompt,
      context = context,
      stream = true,
    },
    stream = vim.schedule_wrap(function(_, chunk, job)
      local res = vim.json.decode(chunk)
      cb(res)
    end),
    raw = { '-N' },
  })
  vim.notify('requested...', vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('ChotGPT', function()
  local message = ''
  vim.ui.input({ prompt = 'ChotGPT' }, function(input)
    requestOllama(input, function(res)
      if res.done then
        context = res.context
        vim.notify(message, vim.log.levels.INFO)
      else
        message = message .. res.response
      end
    end)
  end)
end, {})

-- Async
local function requestOllamaAsync(prompt, cb)
  ---@type Job
  local job = require('plenary.curl').post('http://localhost:11434/api/generate', {
    body = vim.json.encode {
      model = 'codellama:7b-code',
      prompt = prompt,
      context = context,
      stream = false,
    },
    callback = vim.schedule_wrap(function(output)
      local body = vim.json.decode(output.body)
      cb(body)
    end),
  })
  vim.notify('requested...', vim.log.levels.INFO)
  return job
end

vim.api.nvim_create_user_command('ChotGPTAsync', function()
  vim.ui.input({ prompt = 'ChotGPTAsync' }, function(input)
    requestOllamaAsync(input, function(res)
      vim.notify(res.response, vim.log.levels.INFO)
      context = res.context
    end)
  end)
end, {})

-- Sync
local function requestOllamaSync(prompt)
  local body = vim.json.encode {
    model = 'mistral',
    prompt = prompt,
    context = context,
    stream = false,
  }
  -- vim.print(body)
  ---@type Job
  local job = require('plenary.curl').post('http://localhost:11434/api/generate', {
    body = body,
    timeout = 1000 * 60 * 1,
  })
  -- vim.print(job)
  local body = vim.fn.json_decode(job.body)
  return body
end

vim.api.nvim_create_user_command('ChotGPTSync', function()
  vim.ui.input({ prompt = 'ChotGPTSync' }, function(input)
    local res = requestOllamaSync(input)
    vim.notify(res.response, vim.log.levels.INFO)
  end)
end, {})

vim.api.nvim_create_user_command('ChatOllama', function()
  -- local bufnr = vim.api.nvim_create_buf(true, false)
  vim.cmd.new()
  local bufnr = vim.fn.bufnr()
  vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { '## YOU', '' })
  vim.bo[bufnr].modified = false
  vim.bo[bufnr].buftype = 'prompt'
  vim.bo[bufnr].filetype = 'markdown'
  vim.opt_local.wrap = true

  vim.fn.prompt_setprompt(bufnr, ' ')
  vim.fn.prompt_setcallback(bufnr, function(text)
    vim.api.nvim_buf_set_lines(bufnr, -2, -2, false, { '', '## Ollama', '', '' })
    requestOllama(text, function(res)
      if res.done then
        context = res.context
        vim.api.nvim_buf_set_lines(bufnr, -2, -2, false, { '', '## You', '' })
        vim.bo[bufnr].modified = false
      else
        if res.response then
          local lastline = vim.api.nvim_buf_get_lines(bufnr, -3, -2, false)
          local mes
          if lastline[1] then
            mes = lastline[1] .. res.response
          else
            mes = res.response
          end
          local lines = vim.split(mes, '\n')
          vim.api.nvim_buf_set_lines(bufnr, -3, -2, false, lines)
        else
          vim.api.nvim_buf_set_lines(bufnr, -2, -2, false, { 'Error...' })
        end
      end
    end)
  end)
end, {})

vim.api.nvim_create_user_command('ChatOllamaAsync', function()
  -- local bufnr = vim.api.nvim_create_buf(true, false)
  vim.cmd.new()
  local bufnr = vim.fn.bufnr()
  vim.bo[bufnr].buftype = 'prompt'
  vim.bo[bufnr].filetype = 'markdown'
  vim.fn.appendbufline(bufnr, 0, '## YOU')
  vim.bo[bufnr].modified = false

  vim.fn.prompt_setprompt(bufnr, ' ')
  vim.fn.prompt_setcallback(bufnr, function(text)
    vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, '')
    -- vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, '## Echo')
    -- vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, text)
    -- vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, '')
    vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, '## Ollama')
    requestOllamaAsync(text, function(res)
      if res and res.response then
        vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, res.response)
        vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, '')
        context = res.context
      else
        vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, 'Error...')
      end
      vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, '## You')
      vim.bo[bufnr].modified = false
    end)
  end)
end, {})

vim.api.nvim_create_user_command('ChatOllamaSync', function()
  -- local bufnr = vim.api.nvim_create_buf(true, false)
  vim.cmd.new()
  local bufnr = vim.fn.bufnr()
  vim.bo[bufnr].buftype = 'prompt'
  vim.bo[bufnr].filetype = 'markdown'
  vim.fn.appendbufline(bufnr, 0, '## YOU')
  vim.bo[bufnr].modified = false

  vim.fn.prompt_setprompt(bufnr, ' ')
  vim.fn.prompt_setcallback(bufnr, function(text)
    vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, '')
    vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, '## Echo')
    vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, text)
    vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, '')
    vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, '## Ollama')
    local res = requestOllamaSync(text)
    if res and res.response then
      vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, res.response)
      vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, '')
      context = res.context
    else
      vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, 'Error...')
    end
    vim.fn.appendbufline(bufnr, vim.api.nvim_buf_line_count(bufnr) - 1, '## You')
    vim.bo[bufnr].modified = false
  end)
end, {})

local ns_id = vim.api.nvim_create_namespace 'Opilot'

local function requestOpilot()
  local pos = vim.api.nvim_win_get_cursor(0)
  local lines

  lines = vim.api.nvim_buf_get_text(0, 0, 0, pos[1] - 1, pos[2], {})
  local prefix = table.concat(lines, '\n')
  lines = vim.api.nvim_buf_get_text(0, pos[1] - 1, pos[2], -1, -1, {})
  local suffix = table.concat(lines, '\n')

  local prompt = '<PRE> ' .. prefix .. ' <SUF>' .. suffix .. ' <MID>'
  local job = requestOllamaAsync(prompt, function(body)
    -- vim.print(body.response)
    local response = string.gsub(body.response, ' <EOT>$', '')
    vim.print(response)
    local lines = vim.split(response, '\n')
    local virt_text = table.remove(lines, 1)
    local opts = {}
    opts.virt_text = { { virt_text, 'Comment' } }
    opts.virt_text_pos = 'overlay'
    opts.virt_lines = {}
    for _, value in pairs(lines) do
      table.insert(opts.virt_lines, { { value, 'Comment' } })
    end
    vim.print(opts)
    local virt_text_id = vim.api.nvim_buf_set_extmark(0, ns_id, pos[1] - 1, pos[2], opts)

    vim.keymap.set('i', '<C-f>', function()
      vim.print 'accept'
      vim.api.nvim_buf_set_text(0, pos[1] - 1, pos[2], pos[1] - 1, pos[2], vim.split(response, '\n'))
      vim.api.nvim_buf_del_extmark(0, ns_id, virt_text_id)
      vim.keymap.del('i', '<C-f>')
    end)
    vim.api.nvim_create_autocmd('InsertLeave', {
      once = true,
      pattern = '*',
      callback = function()
        vim.api.nvim_buf_del_extmark(0, ns_id, virt_text_id)
      end,
    })
  end)
  vim.api.nvim_create_autocmd({ 'TextChangedI', 'CursorMovedI', 'InsertLeave' }, {
    once = true,
    pattern = '*',
    callback = function()
      job:shutdown()
    end,
  })
end

-- vim.api.nvim_create_autocmd('CursorHoldI', {
--   once = true,
--   group = vim.api.nvim_create_augroup('HogeHoge', {}),
--   pattern = '*',
--   callback = requestOpilot,
-- })

vim.api.nvim_create_autocmd('User', {
  once = true,
  pattern = 'VeryLazy',
  callback = function()
    vim.api.nvim_create_user_command('LazyLoadAllPlugins', function()
      local specs = require('lazy').plugins()
      local names = {}
      for _, spec in pairs(specs) do
        -- vim.pretty_print(value)
        if spec.lazy and not spec['_'].loaded and not spec['_'].dep and not spec['_'].cond then
          table.insert(names, spec.name)
        end
      end
      require('lazy').load { plugins = names }
    end, {})
  end,
})

-- local TIMEOUT = 500
-- local n = 0
-- local timer = vim.loop.new_timer()
-- vim.on_key(function()
--   timer:start(TIMEOUT, 0, function()
--     n = n + 1
--     print(n)
--   end)
-- end)

---@type LazySpec[]
local spec = {
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    dependencies = 'nvim-tree/nvim-web-devicons',
    init = function()
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.silent = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Lua
      map('n', '<Space>xx', '<cmd>Trouble<cr>', { desc = 'Trouble' })
      map('n', '<Space>xw', '<cmd>Trouble workspace_diagnostics<cr>', { desc = 'Trouble workspace_diagnostics' })
      map('n', '<Space>xd', '<cmd>Trouble document_diagnostics<cr>', { desc = 'Trouble document_diagnostics' })
      -- map('n', '<Space>xl', '<cmd>Trouble loclist<cr>', { desc = 'Trouble loclist' })
      -- map('n', '<Space>xq', '<cmd>Trouble quickfix<cr>', { desc = 'Trouble quickfix' })
      map('n', '<Space>gR', '<cmd>Trouble lsp_references<cr>', { desc = 'Trouble lsp_references' })
    end,
    config = function()
      require('trouble').setup {
        use_diagnostic_signs = true,
      }
    end,
  },

  {
    'yuys13/partedit.vim',
    keys = {
      { '<Space>pe', '<Plug>(partedit_start_context)' },
    },
    cmd = { 'PartEdit', 'PartEditContext' },
    dependencies = { { 'Shougo/context_filetype.vim' } },
  },

  {
    'lambdalisue/gina.vim',
    cmd = 'Gina',
    config = function()
      vim.fn['gina#custom#mapping#nmap']('status', '<C-l>', '<Cmd>e<CR>', { noremap = 1, silent = 1 })
    end,
  },

  {
    'kannokanno/previm',
    ft = { 'markdown', 'rst', 'asciidoc' },
    dependencies = {
      {
        'tyru/open-browser.vim',
        keys = {
          { 'gx', '<Plug>(openbrowser-smart-search)', mode = { 'n', 'x' } },
        },
        init = function()
          vim.g.netrw_nogx = 1 -- disable netrw's gx mapping.
        end,
      },
    },
  },

  {
    't9md/vim-quickhl',
    keys = {
      { '<Space>hl', '<Plug>(quickhl-manual-this)' },
    },
    config = function()
      -- vim.keymap.set('n', '<Space>hl', '<Plug>(quickhl-manual-this)', {})
      vim.keymap.set('n', '<Space>nohl', '<Plug>(quickhl-manual-reset)', {})
    end,
  },

  {
    'kassio/neoterm',
    cmd = 'Tnew',
    init = function()
      vim.keymap.set('n', '<Space>nl', '<Cmd>rightbelow vertical Tnew<CR>', {})
      vim.keymap.set('n', '<Space>nh', '<Cmd>vertical Tnew<CR>', {})
      vim.keymap.set('n', '<Space>nn', '<Plug>(neoterm-repl-send-line)', {})
      vim.keymap.set('x', '<Space>nn', '<Plug>(neoterm-repl-send)', {})
    end,
  },

  {
    'machakann/vim-sandwich',
    keys = { 'y', 'd', 'c', { 'S', mode = 'x' } },
    config = function()
      vim.cmd [[runtime macros/sandwich/keymap/surround.vim]]
      vim.fn['operator#sandwich#set']('add', 'char', 'skip_space', 1)
    end,
  },

  {
    'monaqa/dial.nvim',
    keys = {
      { '<C-a>', '<Plug>(dial-increment)', mode = { 'n', 'v' }, desc = 'dial increment' },
      { '<C-x>', '<Plug>(dial-decrement)', mode = { 'n', 'v' }, desc = 'dial decrement' },
      { 'g<C-a>', mode = 'v' },
      { 'g<C-x>', mode = 'v' },
    },
    config = function()
      vim.keymap.set('v', 'g<C-a>', function()
        require('dial.map').manipulate('increment', 'gvisual')
      end, { desc = 'dial increment gvisual' })
      vim.keymap.set('v', 'g<C-x>', function()
        require('dial.map').manipulate('decrement', 'gvisual')
      end, { desc = 'dial decrement gvisual' })
    end,
  },

  {
    'stevearc/aerial.nvim',
    cmd = 'AerialToggle',
    config = function()
      require('aerial').setup {
        backends = { 'lsp', 'treesitter', 'markdown', 'man' },
        lazy_load = true,
        layout = {
          win_opts = { winblend = 30 },
        },
        -- show_guides = true,
        float = {
          relative = 'win',
          override = function(conf, source_winid)
            conf.col = vim.fn.winwidth(source_winid)
            conf.row = 0
            vim.pretty_print(conf)
            return conf
          end,
        },
      }
      local ok, telescope = pcall(require, 'telescope')
      if ok then
        telescope.load_extension 'aerial'
      end
    end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    cmd = 'NvimTreeToggle',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icon
    },
    config = function()
      require('nvim-tree').setup {
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      }
    end,
  },

  {
    'cohama/lexima.vim',
    event = 'InsertEnter',
    init = function()
      vim.g.lexima_ctrlh_as_backspace = 1
      vim.g.lexima_enable_space_rules = 0
    end,
    config = function()
      vim.keymap.set('i', 'jj', '<Esc>', { remap = true })
    end,
  },

  { 'itchyny/vim-qfedit', ft = 'qf' },

  { 'thinca/vim-qfreplace', ft = 'qf' },

  {
    'AndrewRadev/linediff.vim',
    cmd = 'Linediff',
    init = function()
      vim.g.linediff_modify_statusline = 0
      vim.g.linediff_first_buffer_command = 'topleft new'
      vim.g.linediff_second_buffer_command = 'vertical new'
      local augroup = vim.api.nvim_create_augroup('LinediffAutoCmd', {})
      vim.api.nvim_create_autocmd('User', {
        group = augroup,
        pattern = 'LinediffBufferReady',
        callback = function()
          vim.keymap.set('n', 'q', '<Cmd>LinediffReset<CR>', { buffer = true })
        end,
      })
    end,
  },

  {
    'mattn/vim-sonictemplate',
    cmd = 'Template',
    init = function()
      vim.g.sonictemplate_key = ''
      vim.g.sonictemplate_intelligent_key = ''
      vim.g.sonictemplate_postfix_key = ''
    end,
  },

  { 'tyru/capture.vim', cmd = 'Capture' },

  { 'Eandrju/cellular-automaton.nvim', cmd = 'CellularAutomaton' },
}

return spec
