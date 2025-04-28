---@type vim.lsp.Config
return {
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
}
