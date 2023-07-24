local M = {
  'simrat39/symbols-outline.nvim',
  keys = { '<leader>go' },
}

function M.config()
  require('symbols-outline').setup {
    require('core.maps').outline()
  }
end

return M
