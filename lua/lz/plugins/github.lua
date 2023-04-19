local M = {
  'projekt0n/github-nvim-theme',
  lazy = false,
  enabled = false,
}

function M.config()
  require("github-theme").setup {
    options = {
      hide_end_of_buffer = true,
      hide_nc_statusline = true,
      transparent = true,
      styles = {
        comments = 'italic',
        functions = 'italic',
        keywords = 'italic',
        variables = 'none',
      },
      darken = {
        floats = true,
        sidebars = {
          enable = true,
        },
      },
    }
  }
  vim.cmd('colorscheme github_dark_default')
end

return M
