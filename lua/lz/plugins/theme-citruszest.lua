local M = {
  "zootedb0t/citruszest.nvim",
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'citruszest',
}

function M.config()
  require("citruszest").setup {
    option = {
      transparent = vim.g.transparent,
      italic = false,
      bold = true,
    },
    style = {
      Constant = { fg = "#FFFFFF", bold = true }
    },
  }
  vim.cmd.colorscheme 'citruszest'
end

return M
