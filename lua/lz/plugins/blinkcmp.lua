return {
  'saghen/blink.cmp',
  lazy = false,
  version = '*',
  dependencies = {
    { 'rafamadriz/friendly-snippets' },
  },
  opts = {
    appearance = { nerd_font_variant = 'mono' },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    signature = { enabled = true },

    completion = {
      ghost_text = { enabled = false },
      list = { selection = { preselect = true, auto_insert = false } },
    },

    keymap = {
      preset = 'super-tab',
      ['<M-j>'] = { 'select_next', 'fallback' },
      ['<M-k>'] = { 'select_prev', 'fallback' },
      ['<M-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-c>'] = { 'hide', 'fallback' },
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-k>'] = { 'fallback' }, -- avoid conflicting with other keymaps
    },

    cmdline = {
      completion = {
        menu = { auto_show = true },
        list = { selection = { preselect = true, auto_insert = false } },
      },
      keymap = {
        preset = 'none',
        ['<Tab>'] = { 'accept' },
        ['<M-j>'] = { 'select_next' },
        ['<M-k>'] = { 'select_prev' },
        ['<C-c>'] = { 'hide' },
      },
    },
  },
}
