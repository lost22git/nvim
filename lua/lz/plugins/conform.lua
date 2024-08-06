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
      lsp_fallback = true,
    },
    formatters_by_ft = {
      -- html       = { 'prettier' },
      javascript = { 'prettier' },
      python     = { 'ruff' },
      crystal    = { 'crystal' },
      sh         = { 'shfmt' },
      nim        = { 'nph' },
    },
    formatters = {
      ruff = {
        command = "ruff",
        args = { "format", "$FILENAME" },
        stdin = false,
      },
      crystal = {
        command = "crystal",
        args = { "tool", "format", "$FILENAME" },
        stdin = false,
      },
      shfmt = {
        command = U.get_lsp_server_path("shfmt"),
        args = { "-l", "-w", "$FILENAME" },
        stdin = false,
      },
      nph = {
        command = "nph",
        args = { "$FILENAME" },
        stdin = false,
      },
    },
  }
end

return M
