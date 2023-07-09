local M = {
  "zioroboco/nu-ls.nvim",
  event = { 'BufReadPost *.nu', 'BufNewFile *.nu' },
}

function M.config()
  require('nu-ls').setup {}
end

return M
