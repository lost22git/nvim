local M = {
  'kvrohit/mellow.nvim',
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'mellow',
}

function M.config()
  vim.g.mellow_italic_comments = false
  vim.g.mellow_bold_keywords = true
  vim.g.mellow_bold_booleans = true
  vim.g.mellow_transparent = vim.g.transparent
  vim.cmd.colorscheme 'mellow'
end

return M
