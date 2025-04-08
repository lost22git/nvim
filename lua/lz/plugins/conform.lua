return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  opts = {
    default_format_opts = { lsp_format = 'fallback' },
    format_on_save = { lsp_format = 'fallback', timeout_ms = 3000 },

    -- see :help conform-formatters
    formatters_by_ft = {
      clojure = { 'cljfmt' },
      crystal = { 'crystal' },
      css = { 'prettier' },
      dart = { 'dart_format' },
      elixir = { 'mix' },
      fennel = { 'fnlfmt' },
      gleam = { 'gleam' },
      go = { 'goimports', 'gofmt' },
      http = { 'kulala-fmt' },
      html = { 'prettier' },
      inko = { 'inko' },
      janet = { 'janet-format' },
      javascript = { 'deno_fmt', 'prettier' },
      jsx = { 'prettier' },
      json = { 'jq', 'prettier' },
      just = { 'just' },
      lua = { 'stylua' },
      nim = { 'nph' },
      ocaml = { 'ocamlformat' },
      python = { 'ruff_format' },
      roc = { 'roc' },
      sh = { 'shfmt' },
      -- swift = { 'swift_format' },
      toml = { 'taplo' },
      zig = { 'zigfmt' },
    },
    formatters = {
      ['janet-format'] = {
        command = 'janet-format',
        stdin = true,
      },
    },
  },
}
