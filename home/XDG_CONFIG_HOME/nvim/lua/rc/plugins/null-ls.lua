return {
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      local null_ls = require 'null-ls'
      null_ls.setup {
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          require('lsp-format').on_attach(client)
          vim.keymap.set(
            'n',
            '<Space>ca',
            vim.lsp.buf.code_action,
            { buffer = bufnr, silent = true, desc = 'LSP code_action' }
          )
          vim.keymap.set('n', '<space>lf', vim.lsp.buf.format, { buffer = bufnr, silent = true, desc = 'LSP format' })
        end,
        sources = {
          -- All
          null_ls.builtins.diagnostics.cspell.with {
            condition = function(utils)
              return utils.root_has_file {
                'cspell.json',
                '.cspell.json',
                'cSpell.json',
                '.cspell.config.json',
              }
            end,
            diagnostics_postprocess = function(diag)
              diag.severity = vim.diagnostic.severity['INFO']
            end,
          },
          null_ls.builtins.code_actions.cspell.with {
            condition = function(utils)
              return utils.root_has_file {
                'cspell.json',
                '.cspell.json',
                'cSpell.json',
                '.cspell.config.json',
              }
            end,
          },
          -- Dockerfile
          null_ls.builtins.diagnostics.hadolint,
          -- Fish shell
          null_ls.builtins.formatting.fish_indent,
          -- Git
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.diagnostics.gitlint,
          -- GitHub Actions
          null_ls.builtins.diagnostics.actionlint,
          -- Go
          -- null_ls.builtins.formatting.gofmt.with {
          --   extra_args = { '-s' },
          -- },
          null_ls.builtins.formatting.goimports,
          -- Javascript
          null_ls.builtins.formatting.prettier.with { prefer_local = 'node_modules/.bin' },
          -- Lua
          null_ls.builtins.diagnostics.luacheck.with {
            condition = function(utils)
              return utils.root_has_file { '.luacheckrc' }
            end,
          },
          null_ls.builtins.formatting.stylua,
          -- Markdown
          null_ls.builtins.diagnostics.markdownlint,
          -- Python
          null_ls.builtins.diagnostics.flake8,
          -- null_ls.builtins.diagnostics.pylint,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          -- null_ls.builtins.formatting.reorder_python_imports,
          -- Shell script
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.formatting.shfmt.with {
            condition = function(utils)
              return utils.root_has_file { '.editorconfig' }
            end,
          },
          -- Text
          null_ls.builtins.diagnostics.textlint.with {
            prefer_local = 'node_modules/.bin',
            filetypes = {
              'asciidoc',
              'html',
              'markdown',
              'rst',
              'text',
              'help',
            },
            condition = function(utils)
              return utils.root_has_file { '.textlintrc' }
            end,
          },
          -- Vim script
          null_ls.builtins.diagnostics.vint,
          -- YAML
          null_ls.builtins.diagnostics.yamllint,
          -- zsh
          null_ls.builtins.diagnostics.zsh,
        },
      }
    end,
  },
}