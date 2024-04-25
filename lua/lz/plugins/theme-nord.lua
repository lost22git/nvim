local M = {
  'shaunsingh/nord.nvim',
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'nord',
}

function M.config()
  vim.g.nord_contrast = false
  vim.g.nord_borders = true
  vim.g.nord_disable_background = vim.g.transparent
  vim.g.nord_cursorline_transparent = false
  vim.g.nord_enable_sidebar_background = false
  vim.g.nord_uniform_diff_background = true
  vim.g.nord_italic = false
  vim.g.nord_bold = false
  vim.cmd.colorscheme 'nord'
end

return M
