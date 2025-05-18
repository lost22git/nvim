(vim.cmd "highlight Pmenu ctermbg=NONE guibg=NONE")

(when (. vim.g.zz :transparent)
  (vim.cmd "highlight Normal ctermbg=NONE guibg=NONE
            highlight NormalFloat ctermbg=NONE guibg=NONE
            highlight EndOfBuffer ctermbg=NONE guibg=NONE
            "))
