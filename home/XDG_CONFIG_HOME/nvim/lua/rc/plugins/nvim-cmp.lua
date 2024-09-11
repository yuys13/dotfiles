---@type LazySpec[]
local spec = {
  {
    'hrsh7th/nvim-cmp',
    -- event = { 'InsertEnter', 'CmdlineEnter' },
    event = 'InsertEnter',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      -- { 'hrsh7th/cmp-cmdline' },
      {
        'tamago324/cmp-zsh',
        enabled = vim.fn.executable 'zsh' == 1,
        config = function()
          require('cmp_zsh').setup { zshrc = false, filetypes = { 'zsh' } }
        end,
      },
      {
        'mtoohey31/cmp-fish',
        enabled = vim.fn.executable 'fish' == 1,
      },
      { 'onsails/lspkind-nvim' },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      -- nvim-cmp setup
      local cmp = require 'cmp'

      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      cmp.setup {
        preselect = cmp.PreselectMode.None,
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            -- vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if vim.snippet.active { direction = 1 } then
              vim.snippet.jump(1)
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function()
            if vim.snippet.active { direction = -1 } then
              vim.snippet.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources({
          { name = 'lazydev' },
        }, {
          { name = 'nvim_lsp' },
          -- { name = 'vsnip' }, -- For vsnip users.
          -- { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          { name = 'path' },
          { name = 'buffer' },
        }),
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = function(entry, vim_item)
            if vim.tbl_contains({ 'path' }, entry.source.name) then
              local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = icon .. ' ' .. vim_item.kind
                vim_item.kind_hl_group = hl_group
                vim_item.menu = '[Path]'
                return vim_item
              end
            end
            return require('lspkind').cmp_format {
              mode = 'symbol_text',
              menu = {
                buffer = '[Buffer]',
                -- cmdline = '[CmdLine]',
                fish = '[fish]',
                lazydev = '[LAZYDEV]',
                nvim_lsp = '[LSP]',
                path = '[Path]',
                vsnip = '[Vsnip]',
                zsh = '[ZSH]',
              },
            }(entry, vim_item)
          end,
        },
      }

      -- Set configuration for specific filetype.
      cmp.setup.filetype('zsh', {
        sources = cmp.config.sources {
          { name = 'zsh' },
          { name = 'path' },
          { name = 'buffer' },
        },
      })
      cmp.setup.filetype('fish', {
        sources = cmp.config.sources {
          { name = 'fish' },
          { name = 'path' },
          { name = 'buffer' },
        },
      })

      -- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline({ '/', '?' }, {
      --   mapping = cmp.mapping.preset.cmdline {
      --     -- ['<C-n>'] = cmp.config.disable,
      --     -- ['<C-p>'] = cmp.config.disable,
      --   },
      --   sources = {
      --     { name = 'buffer' },
      --   },
      -- })
      --
      -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline(':', {
      --   mapping = cmp.mapping.preset.cmdline {
      --     -- ['<C-n>'] = cmp.config.disable,
      --     -- ['<C-p>'] = cmp.config.disable,
      --   },
      --   sources = cmp.config.sources({
      --     { name = 'path' },
      --   }, {
      --     { name = 'cmdline' },
      --   }),
      -- })
    end,
  },
}

return spec
