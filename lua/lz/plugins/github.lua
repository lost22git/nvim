local M = {
  'projekt0n/github-nvim-theme',
  lazy = false,
  enabled = false,
}

function M.config()
  require("github-theme").setup {
    theme_style = "dimmed",
    msg_area_style = 'NONE',
    variable_style = 'NONE',
    comment_style = 'italic',
    keyword_style = 'italic',
    function_style = "italic",
    dark_float = false,
    dark_sidebar = false,
    transparent = true,
  }
end

return M
