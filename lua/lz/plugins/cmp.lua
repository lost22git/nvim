local friendly_snippets = {
  'rafamadriz/friendly-snippets',
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end
}

local luasnip = {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  dependencies = { friendly_snippets },
}

local cmp_luasnip = {
  'saadparwaiz1/cmp_luasnip',
  dependencies = { luasnip },
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
    view = {
      entries = {
        follow_cursor = true,
      }
    },
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
        border = 'single', -- single | rounded | double | solid | shadow | { }
        -- border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        -- col_offset = -3,
        side_padding = 0,
      },
      documentation = {
        border = 'single',
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
