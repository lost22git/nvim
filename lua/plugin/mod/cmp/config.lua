local M = {}

function M.lspkind()
  local lspkind = require("lspkind")
  lspkind.init({
    -- enables text annotations
    --
    -- default: true
    mode = 'symbol',

    -- default symbol map
    -- can be either 'default' (requires nerd-fonts font) or
    -- 'codicons' for codicon preset (requires vscode-codicons font)
    --
    -- default: 'default'
    preset = 'codicons',

    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "ﰠ",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "塞",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "פּ",
      Event = "",
      Operator = "",
      TypeParameter = ""
    },
  })
end

function M.cmp()
  local cmp = require('cmp')
  local lspkind = require('lspkind')
  local maps = require('core.maps')

  ---@diagnostic disable-next-line: redundant-parameter
  cmp.setup({
    mapping = maps.cmp(),
    formatting = {
      format = lspkind.cmp_format {
        with_text = true,
        maxwidth = 100,
        menu = {
          nvim_lsp = "[LS]",
          nvim_lsp_signature_help = "[Sig]",
          buffer = "[Buf]",
          luasnip = "[Snip]",
          treesitter = "[TS]",
          path = "[Path]",
          cmdline = "[Cmd]",
          neorg = "[Norg]",
        },
      }
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
        border = 'single',
        --border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        winhighlight = "Normal:NormalFloat,FloatBorder:TelescopeBorder",
      },
      documentation = {
        -- border = 'rounded',
        border = 'single',
        winhighlight = 'Normal:NormalFloat,FloatBorder:TelescopeBorder',
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

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })
  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  vim.cmd [[
    highlight! default link CmpItemKind CmpItemMenuDefault
  ]]
end

function M.autopairs()
  local ap = require('nvim-autopairs')
  ap.setup {
    disable_filetype = { "TelescopePrompt", "vim" },
  }
end

return M
