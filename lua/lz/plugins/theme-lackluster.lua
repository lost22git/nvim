local M = {
  "slugbyte/lackluster.nvim",
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'lackluster',
}

function M.config()
  local lackluster = require("lackluster")
  -- !must called setup() before setting the colorscheme!
  lackluster.setup {
  }

  vim.cmd.colorscheme("lackluster")
  -- vim.cmd.colorscheme("lackluster-hack")
  -- vim.cmd.colorscheme("lackluster-mint")
  -- vim.cmd.colorscheme("lackluster-dark")
  -- vim.cmd.colorscheme("lackluster-light")
end

return M
