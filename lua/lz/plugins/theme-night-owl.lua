local M = {
  "oxfist/night-owl.nvim",
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'night-owl'
}

function M.config()
  vim.cmd.colorscheme 'night-owl'
end

return M
