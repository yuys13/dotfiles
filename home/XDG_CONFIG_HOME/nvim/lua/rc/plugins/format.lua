---@type LazySpec[]
return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    config = function()
      require('conform').setup {
        default_format_opts = {
          lsp_format = 'fallback',
        },
        format_on_save = {
          lsp_format = 'fallback',
          timeout_ms = 500,
        },
        formatters_by_ft = {
          lua = { 'stylua' },

          bash = { 'shfmt' },
          fish = { 'fish_indent' },
          go = { 'goimports', 'gofmt' },

          javascript = { 'prettier' },
          javascriptreact = { 'prettier' },
          typescript = { 'prettier' },
          typescriptreact = { 'prettier' },

          markdown = { 'prettier', 'injected' },

          python = function(bufnr)
            if require('conform').get_formatter_info('ruff_format', bufnr).available then
              return { 'ruff_format' }
            else
              return { 'isort', 'black' }
            end
          end,
        },
        formatters = {
          gofmt = {
            append_args = { '-s' },
          },
        },
      }
    end,
  },
}
