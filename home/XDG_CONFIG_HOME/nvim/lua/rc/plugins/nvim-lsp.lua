---@type LazySpec[]
local spec = {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- hover settings
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        -- Use a sharp border with `FloatBorder` highlights
        border = 'single',
      })
      -- diagnostic settings
      vim.diagnostic.config {
        virtual_text = {
          -- source = 'always',
        },
        float = {
          -- source = 'always',
          border = 'single',
          title = 'Diagnostics',
          header = {},
          suffix = {},
          format = function(diag)
            if diag.code then
              return string.format('[%s](%s): %s', diag.source, diag.code, diag.message)
            else
              return string.format('[%s]: %s', diag.source, diag.message)
            end
          end,
        },
      }
      -- diagnostic mapping
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = 'LSP diagnostic open_float' })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'LSP diagnostic goto_prev' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'LSP diagnostic goto_next' })
      vim.keymap.set('n', '<space>ql', vim.diagnostic.setqflist, { desc = 'LSP diagnostic setqflist' })
      vim.keymap.set('n', '<space>ll', vim.diagnostic.setloclist, { desc = 'LSP diagnostic setloclist' })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfigBuffer', {}),
        callback = function(event)
          -- Mappings.
          local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = event.buf
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
          map({ 'n', 'x' }, '<space>ca', vim.lsp.buf.code_action, { desc = 'LSP code_action' })
          map('n', '<space>gr', vim.lsp.buf.references, { desc = 'LSP references' })
          map('n', '<space>lf', vim.lsp.buf.format, { desc = 'LSP format' })

          local augroup = vim.api.nvim_create_augroup('LspAutoCmd', {})
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              group = augroup,
              buffer = event.buf,
              callback = function()
                vim.lsp.buf.document_highlight()
              end,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              group = augroup,
              buffer = event.buf,
              callback = function()
                vim.lsp.buf.clear_references()
              end,
            })
          end
        end,
      })

      -- Add additional capabilities supported by nvim-cmp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require 'lspconfig'
      local node_root_dir = lspconfig.util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json')
      local is_node_repo = node_root_dir(vim.fn.getcwd()) ~= nil

      require 'mason'
      local mason_lspconfig = require 'mason-lspconfig'
      mason_lspconfig.setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name)
          lspconfig[server_name].setup { capabilities = capabilities }
        end,
        -- Next, you can provide targeted overrides for specific servers.
        ['jsonls'] = function()
          lspconfig.jsonls.setup {
            capabilities = capabilities,
            settings = {
              json = {
                schemas = require('schemastore').json.schemas(),
              },
            },
          }
        end,
        ['rust_analyzer'] = function()
          lspconfig.rust_analyzer.setup {
            on_attach = function(client, bufnr)
              require('lsp-format').on_attach(client)
            end,
            capabilities = capabilities,
            settings = {
              ['rust-analyzer'] = {
                check = {
                  command = 'clippy',
                },
              },
            },
          }
        end,
        ['lua_ls'] = function()
          require('neodev').setup {}
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            on_attach = function(client)
              client.server_capabilities.semanticTokensProvider = nil
            end,
            settings = {
              Lua = {
                -- runtime = {
                --   path = { '?.lua', '?/init.lua' },
                --   pathStrict = true,
                --   version = 'LuaJIT',
                -- },
                workspace = {
                  checkThirdParty = false,
                  -- Make the server aware of Neovim runtime files
                  -- library = vim.api.nvim_get_runtime_file('lua', true),
                },
              },
            },
          }
        end,
        ['tsserver'] = function()
          if not is_node_repo then
            return
          end
          lspconfig.tsserver.setup {
            server = {
              capabilities = capabilities,
              single_file_support = false, -- for denols
            },
          }
        end,
      }

      if vim.fn.executable 'deno' == 1 and not is_node_repo then
        lspconfig.denols.setup {
          capabilities = capabilities,
        }
      end
    end,
    dependencies = {
      {
        'williamboman/mason.nvim',
        cmd = 'Mason',
        build = ':MasonUpdate',
        config = function()
          require('mason').setup {
            ui = {
              border = 'single',
            },
          }
          require 'mason-lspconfig'
        end,
      },
      { 'williamboman/mason-lspconfig.nvim', config = true },
      { 'folke/neodev.nvim' },
      { 'b0o/SchemaStore.nvim' },
    },
  },

  {
    'ray-x/lsp_signature.nvim',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      require('lsp_signature').setup()
    end,
  },

  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    config = function()
      require('fidget').setup {
        notification = {
          view = {
            stack_upwards = false,
          },
        },
      }
    end,
  },

  {
    'lukas-reineke/lsp-format.nvim',
    config = function()
      require('lsp-format').setup { sync = true }
    end,
  },
}

return spec
