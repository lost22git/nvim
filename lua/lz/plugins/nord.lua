local M = {
  'shaunsingh/nord.nvim',
  lazy = false,
  priority = 1000,
  enabled = function() return vim.g.theme == 'nord' end,
}

function M.config()
  require('nord').setup {
    vim.cmd.colorscheme 'nord'
  }
end

return M
