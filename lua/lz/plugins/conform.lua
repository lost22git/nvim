local M = {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' }
}

function M.config()
  require('conform').setup {
    formatters_by_ft = {
      javascript = { 'prettier' },
      python     = { 'black' },
      crystal    = { 'crystal' }
    },
    formatters = {
      crystal = {
        command = "crystal",
        args = { "tool", "format", "$FILENAME" },
        stdin = false,
      },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  }
end

return M
