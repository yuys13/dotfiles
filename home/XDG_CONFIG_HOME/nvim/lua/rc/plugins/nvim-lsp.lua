-- local signs = { Error = '󰅚 ', Warn = '󰀪 ', Hint = '󰌶 ', Info = ' ' }
-- for type, icon in pairs(signs) do
--   local hl = 'DiagnosticSign' .. type
--   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end
---@type LazySpec[]
local spec = {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- diagnostic settings
      vim.diagnostic.config {
        severity_sort = true,
        virtual_text = {
          -- source = 'if_many',
        },
        jump = {
          float = true,
        },
        float = {
          -- source = 'if_many',
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
      vim.keymap.set('n', '<space>ql', vim.diagnostic.setqflist, { desc = 'LSP diagnostic setqflist' })
      vim.keymap.set('n', '<space>ll', vim.diagnostic.setloclist, { desc = 'LSP diagnostic setloclist' })

      -- inlay hint
      vim.api.nvim_create_user_command('LspInlayHintToggle', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = 'Toggle inlay_hint' })

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
          map('n', 'K', function()
            vim.lsp.buf.hover { border = 'single' }
          end, { desc = 'LSP hover' })
          map('n', '<space>gi', vim.lsp.buf.implementation, { desc = 'LSP implementation' })
          map('n', '<C-k>', function()
            vim.lsp.buf.signature_help { border = 'single' }
          end, { desc = 'LSP signature_help' })
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
          if client and client.server_capabilities.documentHighlightProvider then
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
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      require 'mason'
      local ls_from_mason = require('mason-lspconfig').get_installed_servers()

      vim.lsp.config('jsonls', {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
          },
        },
      })

      vim.lsp.config('rust_analyzer', {
        on_attach = function(client)
          require('lsp-format').on_attach(client)
        end,
        settings = {
          ['rust-analyzer'] = {
            check = {
              command = 'clippy',
            },
          },
        },
      })

      vim.lsp.config('lua_ls', {
        on_attach = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              path = { '?.lua', '?/init.lua' },
              pathStrict = true,
              version = 'LuaJIT',
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME .. '/lua',
                -- Depending on the usage, you might want to add additional paths here.
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              },
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
              -- library = vim.api.nvim_get_runtime_file('lua', true),
            },
            hint = {
              enable = true,
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })

      vim.lsp.config('ts_ls', {
        root_dir = function(bufnr, callback)
          local found_dirs = vim.fs.find({
            'package.json',
          }, {
            upward = true,
            path = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))),
          })
          if #found_dirs > 0 then
            return callback(vim.fs.dirname(found_dirs[1]))
          end
        end,
      })

      vim.lsp.enable(ls_from_mason)

      vim.lsp.config('denols', {
        root_dir = function(bufnr, callback)
          local found_dirs = vim.fs.find({
            'deno.json',
            'deno.jsonc',
            'deps.ts',
          }, {
            upward = true,
            path = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))),
          })
          if #found_dirs > 0 then
            return callback(vim.fs.dirname(found_dirs[1]))
          end
        end,
      })
      vim.lsp.enable 'denols'

      vim.lsp.config('nil_ls', {
        on_attach = function(client)
          require('lsp-format').on_attach(client)
        end,
        settings = {
          ['nil'] = {
            formatting = {
              command = { 'nixfmt' },
            },
          },
        },
      })
      vim.lsp.enable 'nil_ls'
    end,
  },
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    build = ':MasonUpdate',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('mason').setup {
        ui = {
          border = 'single',
        },
      }
      require 'mason-lspconfig'
    end,
  },
  { 'williamboman/mason-lspconfig.nvim', config = true },
  { 'b0o/SchemaStore.nvim' },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('lazydev').setup {
        library = {
          -- Library items can be absolute paths
          -- "~/projects/my-awesome-lib",
          -- Or relative, which means they will be resolved as a plugin
          -- "LazyVim",
          -- When relative, you can also provide a path to the library in the plugin dir
          'lazy.nvim',
          'luvit-meta/library', -- see below
          'plenary.nvim',
          '${3rd}/busted/library',
          '${3rd}/luassert/library',
        },
      }
    end,
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  -- { 'LuaCATS/busted', lazy = true },
  -- { 'LuaCATS/luassert', lazy = true },

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
          -- filter = vim.log.levels.DEBUG,
          view = {
            stack_upwards = false,
          },
        },
        integration = {
          ['nvim-tree'] = {
            enable = false,
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
