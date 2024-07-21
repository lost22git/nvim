local M = {
  "diegoulloao/neofusion.nvim",
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'neofusion',
}

function M.config()
  require("neofusion").setup {
    terminal_colors = true,
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = false,
      emphasis = false,
      comments = false,
      operators = false,
      folds = false,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = false,
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = vim.g.transparent,
  }

  vim.cmd [[ colorscheme neofusion ]]
end

return M
