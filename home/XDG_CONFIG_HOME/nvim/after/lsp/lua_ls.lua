return {
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
}
