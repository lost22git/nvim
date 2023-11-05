local M = {
  'lukas-reineke/headlines.nvim',
  ft = { 'markdown', 'md', 'norg' },
}

function M.config()
  require('headlines').setup {

  }
end

return M
