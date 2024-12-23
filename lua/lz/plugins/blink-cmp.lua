return {
  "saghen/blink.cmp",
  enabled = vim.g.cmp == "blink",
  lazy = false,
  dependencies = { "rafamadriz/friendly-snippets" },
  -- build = [[RUSTC_BOOTSTRAP=1 cargo build --release]],
  version = "*",

  opts = {
    keymap = require("core.maps").blink_cmp(),
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    signature = { enabled = true },
  },
  opts_extend = { "sources.default" },
}
