vim.cmd([[
    highlight Pmenu ctermbg=NONE guibg=NONE
    "highlight link MiniPickMatchCurrent PmenuSel
    "highlight link MiniPickNormal CmpItemMenu
]])

if vim.g.LC.transparent then
  vim.cmd([[
    highlight Normal ctermbg=NONE guibg=NONE
    highlight NormalFloat ctermbg=NONE guibg=NONE
    highlight EndOfBuffer ctermbg=NONE guibg=NONE
  ]])
end
