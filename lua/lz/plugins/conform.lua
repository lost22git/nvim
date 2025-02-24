return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  opts = {
    format_on_save = {
      timeout_ms = 3000,
      quiet = false,
      lsp_format = 'fallback',
    },

    -- see :help conform-formatters
    formatters_by_ft = {
      clojure = { 'cljfmt' },
      crystal = { 'crystal' },
      dart = { 'dart_format' },
      elixir = { 'mix' },
      fennel = { 'fnlfmt' },
      gleam = { 'gleam' },
      go = { 'goimports', 'gofmt' },
      http = { 'kulala-fmt' },
      inko = { 'inko' },
      javascript = { 'deno_fmt' },
      json = { 'jq' },
      just = { 'just' },
      lua = { 'stylua' },
      nim = { 'nph' },
      ocaml = { 'ocamlformat' },
      python = { 'ruff_format' },
      roc = { 'roc' },
      sh = { 'shfmt' },
      -- swift = { "swiftformat" },
      zig = { 'zigfmt' },
    },
    formatters = {
      shfmt = {
        command = require('core.utils').get_lsp_server_path('shfmt'),
        args = { '-l', '-w', '$FILENAME' },
        stdin = false,
      },
    },
  },
}
