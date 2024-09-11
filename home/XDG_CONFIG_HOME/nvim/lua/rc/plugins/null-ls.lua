---@type LazySpec[]
local spec = {
  {
    'nvimtools/none-ls.nvim',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      local null_ls = require 'null-ls'
      local cspell = require 'cspell'
      null_ls.setup {
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          require('lsp-format').on_attach(client)
        end,
        sources = {
          -- All
          cspell.diagnostics.with {
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
          cspell.code_actions.with {
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
          require('none-ls-luacheck.diagnostics.luacheck').with {
            condition = function(utils)
              return utils.root_has_file { '.luacheckrc' }
            end,
          },
          null_ls.builtins.formatting.stylua,
          -- Markdown
          null_ls.builtins.diagnostics.markdownlint,
          -- Python
          require 'none-ls.diagnostics.flake8',
          -- null_ls.builtins.diagnostics.pylint,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          -- null_ls.builtins.formatting.reorder_python_imports,
          -- Shell script
          -- require 'none-ls-shellcheck.diagnostics', -- use bash-language-server
          require 'none-ls-shellcheck.code_actions',
          null_ls.builtins.formatting.shfmt.with {
            condition = function(utils)
              return utils.root_has_file { '.editorconfig' }
            end,
          },
          -- Text
          null_ls.builtins.diagnostics.textlint.with {
            prefer_local = 'node_modules/.bin',
            extra_filetypes = {
              'asciidoc',
              'html',
              'rst',
              'help',
            },
            condition = function(utils)
              return utils.root_has_file {
                '.textlintrc',
                '.textlintrc.js',
                '.textlintrc.json',
                '.textlintrc.yml',
                '.textlintrc.yaml',
              }
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
  { 'davidmh/cspell.nvim' },
  { 'nvimtools/none-ls-extras.nvim' },
  { 'gbprod/none-ls-luacheck.nvim' },
  { 'gbprod/none-ls-shellcheck.nvim' },
}

return spec
