local function aya()
  -- local start = vim.fn.getpos 'v'
  -- local en = vim.fn.getpos '.'
  -- local mode = vim.api.nvim_get_mode()
  -- local text = vim.fn.getregion(start, en, { type = mode.mode })
  -- vim.print(text)
  vim.print(vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = vim.fn.mode() }))
  local lines = vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = vim.fn.mode() })
  vim.system(
    {
      'curl',
      '-sSL',
      '--compressed',
      '-d',
      vim.json.encode {
        model = 'aya',
        system = '日本語訳してください。',
        prompt = table.concat(lines, '\n'),
        stream = false,
      },
      'http://localhost:11434/api/generate',
    },
    { text = true },
    vim.schedule_wrap(function(out)
      vim.print(vim.inspect(out))
      local res = vim.json.decode(out.stdout)
      vim.print(vim.inspect(res.response))
    end)
  )
  ---@Job
  -- local aaa = require('plenary.curl').post('http://localhost:11434/api/generate', {
  --   body = vim.json.encode {
  --     model = 'aya',
  --     system = '日本語訳してください。',
  --     prompt = table.concat(lines, '\n'),
  --     stream = false,
  --   },
  --   callback = vim.schedule_wrap(function(output)
  --     require 'collama.api' -- for get type annotation
  --     ---@type CollamaGenerateResponse
  --     local res = vim.json.decode(output.body)
  --     vim.print(res.response)
  --   end),
  -- })
end

local function stream_test()
  vim.system(
    {
      'curl',
      '-sSL',
      '-N',
      '--compressed',
      '-d',
      vim.json.encode {
        model = 'aya',
        prompt = 'Why is the sky blue?',
        stream = true,
      },
      'http://localhost:11434/api/generate',
    },
    {
      stdout = function(err, data)
        -- vim.print('err:' .. vim.inspect(err))
        -- vim.print('data:' .. vim.inspect(data))
        if not data then
          vim.print 'data is nil'
          vim.print('err:' .. vim.inspect(err))
          return
        end
        local res = vim.json.decode(data)
        if res.done == false then
          vim.print(vim.inspect(res.response))
        else
          vim.print(vim.inspect(res))
        end
      end,
      text = true,
    },
    vim.schedule_wrap(function(out)
      vim.print('out:' .. vim.inspect(out))
      -- local res = vim.json.decode(out.stdout)
      -- vim.print(vim.inspect(res.response))
    end)
  )
end

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
      model = 'aya',
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
    model = 'llama3',
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

return {}
