local M = {
  "sekke276/dark_flat.nvim",
  lazy = false,
  priority = 1000,
  enabled = function() return vim.g.theme == 'dark_flat' end,
}

function M.config()
  require("dark_flat").setup {
    transparent = vim.g.transparent,
    italics = false,
    colors = {},
    themes = function(colors)
      return {}
    end,
  }
  vim.cmd.colorscheme 'dark_flat'
end

return M
