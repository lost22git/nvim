local M = {
  "scottmckendry/cyberdream.nvim",
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'cyberdream',
}

function M.config()
  vim.cmd.colorscheme('cyberdream')
end

return M
