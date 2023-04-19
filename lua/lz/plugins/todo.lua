local M = {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { 'BufReadPost', 'BufNewFile' },
}

function M.config()
  require("todo-comments").setup {}
  require('core.maps').todo()
end

return M
