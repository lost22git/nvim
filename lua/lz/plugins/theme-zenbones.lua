local M = {
  "mcchrish/zenbones.nvim",
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'zenbones',
  dependencies = {
    "rktjmp/lush.nvim"
  }
}

function M.config()
  vim.g.tokyobones_lightness = 'dim' -- bright | dim
  vim.g.tokyobones_darkness = 'warm' -- stark | warm
  vim.g.tokyobones_transparent_background = vim.g.transparent
  vim.g.tokyobones_italic_comments = true
  vim.g.tokyobones_lighten_noncurrent_window = true
  vim.g.tokyobones_darken_noncurrent_window = true
  vim.cmd.colorscheme 'rosebones'
end

return M
