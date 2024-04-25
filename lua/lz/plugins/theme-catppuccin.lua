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

  local themes = {
    dark = {
      'catppuccin-frappe',
      'catppuccin-macchiato',
      'catppuccin-mocha',
    },
    light = {
      'catppuccin-latte'
    },
  }
  local bg = vim.o.background
  vim.cmd.colorscheme(themes[bg][vim.fn.rand() % vim.fn.len(themes[bg]) + 1])
end

return M
