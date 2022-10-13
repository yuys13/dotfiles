-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Mappings.
  local opts = { buffer = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>lq', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<space>lf', vim.lsp.buf.format, opts)
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

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
  -- for reading-vimrc
  -- ['sumneko_lua'] = function(opts)
  --   local runtime_path = vim.split(package.path, ';')
  --   table.insert(runtime_path, 'lua/?.lua')
  --   table.insert(runtime_path, 'lua/?/init.lua')
  --
  --   opts.settings = {
  --     Lua = {
  --       runtime = {
  --         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the
  --         version = 'LuaJIT',
  --         -- Setup your lua path
  --         path = runtime_path,
  --       },
  --       diagnostics = {
  --         -- Get the language server to recognize the `vim` global
  --         globals = { 'vim' },
  --       },
  --       workspace = {
  --         -- Make the server aware of Neovim runtime files
  --         library = vim.api.nvim_get_runtime_file('', true),
  --       },
  --       -- Do not send telemetry data containing a randomized but unique identifier
  --       telemetry = {
  --         enable = false,
  --       },
  --     },
  --   }
  -- end,
}

require('lua-dev').setup {}
local mason = require 'mason'
mason.setup {}

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
local lspconfig = require 'lspconfig'
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
