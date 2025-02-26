return {
  'saghen/blink.cmp',
  lazy = false,
  -- build = [[RUSTC_BOOTSTRAP=1 cargo build --release]],
  version = '*',
  dependencies = {
    { 'rafamadriz/friendly-snippets' },
  },
  opts = {
    keymap = {
      preset = 'super-tab',
      ['<M-j>'] = { 'select_next', 'fallback' },
      ['<M-k>'] = { 'select_prev', 'fallback' },
      ['<C-c>'] = { 'hide', 'fallback' },
      ['<M-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    },
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
      nerd_font_variant = 'mono',
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    signature = { enabled = true },
  },
}
