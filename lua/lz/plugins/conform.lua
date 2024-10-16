local M = {
  'stevearc/conform.nvim',
  enabled = not vim.g.vscode,
  event = { 'BufWritePre' },
}

function M.config()
  local U = require('core.utils')
  require('conform').setup {
    format_on_save = {
      timeout_ms = 1000,
      async = false,
      quiet = false,
      lsp_format = "fallback",
    },
    -- see :help conform-formatters
    formatters_by_ft = {
      go         = { "goimports", "gofmt" },
      javascript = { 'deno_fmt' },
      python     = { 'ruff_format' },
      crystal    = { 'crystal' },
      sh         = { 'shfmt' },
      nim        = { 'nph' },
      inko       = { 'inko' },
      roc        = { 'roc' },
      gleam      = { 'gleam' },
      ocaml      = { 'ocamlformat' },
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
  }
end

return M
