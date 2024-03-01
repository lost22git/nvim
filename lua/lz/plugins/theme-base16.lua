local M = {
  "RRethy/base16-nvim",
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'base16'
}

function M.config()
  -- require('base16-colorscheme').setup {}
  vim.cmd.colorscheme 'base16-still-alive'
end

return M
