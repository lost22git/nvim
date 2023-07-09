local M = {
  "nyoom-engineering/oxocarbon.nvim",
  lazy = false,
  priority = 1000,
  enabled = function() return vim.g.theme == 'oxocarbon' end,
}

function M.config()
  require('oxocarbon').setup {
  }
  vim.cmd.colorscheme 'oxocarbon'
end

return M
