local M =
{
  'yorik1984/newpaper.nvim',
  enabled = vim.g.theme == 'newpaper',
  lazy = false,
  priority = 1000,
}

function M.config()
  require('newpaper').setup {
    style = vim.o.background,
    italic_strings = false,
    italic_comments = false,
    italic_doc_comments = false,
    italic_functions = false,
    italic_variables = false,
  }
end

return M
