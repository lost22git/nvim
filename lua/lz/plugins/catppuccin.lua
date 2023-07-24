local M = {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'catppuccin'
}

function M.config()
  require('catppuccin').setup {
    transparent_background = vim.g.transparent
  }
  vim.cmd.colorscheme 'catppuccin-frappe'
end

return M
