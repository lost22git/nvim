local M = {
  'stevearc/conform.nvim',
  enabled = not vim.g.vscode,
  event = { 'BufWritePre' },
}

function M.config()
  local U = require('core.utils')
  require('conform').setup({
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
        command = U.get_lsp_server_path('shfmt'),
        args = { '-l', '-w', '$FILENAME' },
        stdin = false,
      },
      nph = {
        command = 'nph',
        args = { '$FILENAME' },
        stdin = false,
      },
    },
  })
end

return M
