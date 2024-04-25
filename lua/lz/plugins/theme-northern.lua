local M = {
  "fcancelinha/northern.nvim",
  branch = "master",
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'northern'
}

function M.config()
  vim.cmd.colorscheme('northern')
end

return M
