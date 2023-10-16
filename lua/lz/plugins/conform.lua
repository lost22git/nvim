local M = {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' }
}

function M.config()
  local U = require('core.utils')
  require('conform').setup {
    formatters_by_ft = {
      javascript = { 'prettier' },
      python     = { 'black' },
      crystal    = { 'crystal' },
      sh         = { 'shfmt' },
    },
    formatters = {
      crystal = {
        command = "crystal",
        args = { "tool", "format", "$FILENAME" },
        stdin = false,
      },
      shfmt = {
        command = U.get_lsp_server_path("shfmt"),
        args = { "-l", "-w", "$FILENAME" },
        stdin = false,
      }
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  }
end

return M
