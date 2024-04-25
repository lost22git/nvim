local M = {
  "briones-gabriel/darcula-solid.nvim",
  dependencies = { "rktjmp/lush.nvim" },
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'darcula',
}

function M.config()
  vim.cmd.colorscheme('darcula-solid')
end

return M
