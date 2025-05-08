vim.cmd([[
    highlight Pmenu ctermbg=NONE guibg=NONE
]])

if vim.g.ZZ.transparent then
  vim.cmd([[
    highlight Normal ctermbg=NONE guibg=NONE
    highlight NormalFloat ctermbg=NONE guibg=NONE
    highlight EndOfBuffer ctermbg=NONE guibg=NONE
  ]])
end
