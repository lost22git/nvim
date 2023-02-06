local cmp_luasnip = {
  'saadparwaiz1/cmp_luasnip',
  dependencies = {
   'L3MON4D3/LuaSnip'
  }
}

local M = {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    -- Snippet
    cmp_luasnip,
    -- Lsp
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    -- Others
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
  },
}

function M.config()
  local cmp = require('cmp')
  local maps = require('core.maps')

  ---@diagnostic disable-next-line: redundant-parameter
  cmp.setup({
    mapping = maps.cmp(),
    formatting = {
      format = require('lz.plugins.lspkind').cmp_format(),
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = 'buffer' },
      { name = 'path' },
      { name = 'luasnip' },
      { name = 'treesitter' },
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = "neorg" },
      { name = "crates" },
    }),
    window = {
      completion = {
        border = 'rounded', -- single | rounded | double | solid | shadow | { }
        --border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        -- col_offset = -3,
        side_padding = 0,
      },
      documentation = {
        border = 'rounded',
        -- winhighlight = 'Normal:TelescopeNormal,FloatBorder:TelescopeBorder',
      }
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    experimental = {
      ghost_text = true,
      native_menu = false,
    },
  })

  --  开启 `native_menu` 后此配置无效
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })
  --  开启 `native_menu` 后此配置无效
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })


end

return M
