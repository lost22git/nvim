local M = {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
}

function M.config()
  local U = require('core.utils')
  require('conform').setup {
    formatters_by_ft = {
      -- html       = { 'prettier' },
      javascript = { 'prettier' },
      -- python     = { 'black' },
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
        command = U.get_lsp_server_path("nph"),
        args = { "$FILENAME" },
        stdin = false,
      },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = false,
    },
  }
end

return M
