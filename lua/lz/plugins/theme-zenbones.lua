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
  vim.cmd.colorscheme 'zenbones'
end

return M
