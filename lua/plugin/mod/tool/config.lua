local M = {}

function M.indent_blankline()
  local bl = require('indent_blankline')
  --vim.g.indent_blankline_char = '┊'
  --vim.g.indent_blankline_char_list = { '|', '¦', '┆', '┊' }
  vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

  bl.setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
    show_end_of_line = true,
    char_highlight_list = {
      -- "IndentBlanklineIndent1",
      -- "IndentBlanklineIndent2",
      -- "IndentBlanklineIndent3",
      -- "IndentBlanklineIndent4",
      -- "IndentBlanklineIndent5",
      "IndentBlanklineIndent6",
    },
  }

end

function M.trouble()
  local trouble = require('trouble')
  trouble.setup {
  }
  require('core.maps').trouble()
end

function M.sj()
  local sj = require('sj')
  sj.setup {
    separator = " ",
  }
  require('core.maps').sj()
end

return M
