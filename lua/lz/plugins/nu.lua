local M = {
  'LhKipp/nvim-nu',
  build = ':TSInstall nu',
  event = { 'BufReadPost *.nu', 'BufNewFile *.nu' }
}

function M.config()
  require('nu').setup {}
end

return M
