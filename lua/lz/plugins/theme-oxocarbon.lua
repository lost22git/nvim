local M = {
  "nyoom-engineering/oxocarbon.nvim",
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'oxocarbon'
}

function M.config()
  vim.cmd.colorscheme 'oxocarbon'
end

return M
