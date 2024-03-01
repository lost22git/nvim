local M = {
  'shaunsingh/nord.nvim',
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'nord',
}

function M.config()
  vim.cmd.colorscheme 'nord'
end

return M



