local M = {
  'datsfilipe/vesper.nvim',
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'vesper',
}

function M.config()
  require('vesper').setup {
    transparent = vim.g.transparent,
    italics = {
      comments = false,
      keywords = false,
      functions = false,
      strings = false,
      variables = false,
    },
  }
  vim.cmd.colorscheme('vesper')
end

return M
