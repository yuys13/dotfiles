local augroup = vim.api.nvim_create_augroup('LspAutoCmd', {})
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Mappings.
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    opts.silent = true
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  map('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP declaration' })
  map('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP definition' })
  map('n', 'K', vim.lsp.buf.hover, { desc = 'LSP hover' })
  map('n', '<space>gi', vim.lsp.buf.implementation, { desc = 'LSP implementation' })
  map('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'LSP signature_help' })
  map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, { desc = 'LSP add_workspace_folder' })
  map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'LSP remove_workspace_folder' })
  map('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = 'LSP list_workspace_folders' })
  map('n', '<space>D', vim.lsp.buf.type_definition, { desc = 'LSP type_definition' })
  map('n', '<space>rn', vim.lsp.buf.rename, { desc = 'LSP rename' })
  map('n', '<space>ca', vim.lsp.buf.code_action, { desc = 'LSP code_action' })
  -- map('n', '<space>gr', vim.lsp.buf.references, { desc = 'LSP references' })
  map('n', '<space>gr', require('telescope.builtin').lsp_references, { desc = 'LSP references' })
  map('n', '<space>e', vim.diagnostic.open_float, { desc = 'LSP diagnostic open_float' })
  map('n', '[d', vim.diagnostic.goto_prev, { desc = 'LSP diagnostic goto_prev' })
  map('n', ']d', vim.diagnostic.goto_next, { desc = 'LSP diagnostic goto_next' })
  map('n', '<space>lq', vim.diagnostic.setloclist, { desc = 'LSP diagnostic setloclist' })
  map('n', '<space>lf', vim.lsp.buf.format, { desc = 'LSP format' })

  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.document_highlight()
    end,
  })
  vim.api.nvim_create_autocmd('CursorMoved', {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.clear_references()
    end,
  })
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require 'lspconfig'
local node_root_dir = lspconfig.util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json')
local is_node_repo = node_root_dir(vim.fn.getcwd()) ~= nil

-- Overriding the default LSP server options
local enhance_server_opts = {
  ['jsonls'] = function(opts)
    opts.settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
      },
    }
  end,
  ['rust_analyzer'] = function(opts)
    opts.on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      require('lsp-format').on_attach(client)
    end
    opts.settings = {
      ['rust-analyzer'] = {
        checkOnSave = {
          command = 'clippy',
        },
      },
    }
  end,
  ['sumneko_lua'] = function(opts)
    opts.settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
          -- Make the server aware of Neovim runtime files
          -- library = vim.api.nvim_get_runtime_file('', true),
        },
      },
    }
  end,
  ['tsserver'] = function(opts)
    opts.root_dir = node_root_dir
  end,
}

require('neodev').setup {}

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup_handlers {
  function(server_name)
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    if enhance_server_opts[server_name] then
      -- Enhance the default opts with the server-specific ones
      enhance_server_opts[server_name](opts)
    end

    lspconfig[server_name].setup(opts)
  end,
}

if vim.fn.executable 'deno' == 1 and not is_node_repo then
  lspconfig.denols.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
