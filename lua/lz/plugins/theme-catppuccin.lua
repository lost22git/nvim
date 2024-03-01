local M = {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'catppuccin'
}

function M.config()
  require('catppuccin').setup {
    transparent_background = vim.g.transparent,
    term_colors = false,
    no_italic = true,
    dim_inactive = {
      enabled = true,
      shade = "dark",
      percentage = 0.15,
    },
  }
  -- vim.cmd.colorscheme 'catppuccin-latte'
  -- vim.cmd.colorscheme 'catppuccin-frappe'
  -- vim.cmd.colorscheme 'catppuccin-macchiato'
  vim.cmd.colorscheme 'catppuccin-mocha'
end

return M
