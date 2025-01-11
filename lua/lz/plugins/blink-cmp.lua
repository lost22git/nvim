return {
  'saghen/blink.cmp',
  lazy = false,
  dependencies = { 'rafamadriz/friendly-snippets' },
  -- build = [[RUSTC_BOOTSTRAP=1 cargo build --release]],
  version = '*',
  opts = {
    keymap = require('core.maps').blink_cmp(),
    completion = {
      ghost_text = { enabled = false },
      list = {
        selection = {
          preselect = function(ctx)
            return ctx.mode ~= 'cmdline' and not require('blink.cmp').snippet_active({ direction = 1 })
          end,
          auto_insert = false,
        },
      },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    signature = { enabled = true },
  },
}
