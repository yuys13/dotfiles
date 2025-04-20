return {
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
}
