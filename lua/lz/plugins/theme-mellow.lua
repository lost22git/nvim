local M = {
  'kvrohit/mellow.nvim',
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'mellow',
}
function M.config()
  vim.cmd.colorscheme 'mellow'
end

return M

