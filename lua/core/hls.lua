-- [nfnl] fnl/core/hls.fnl
vim.cmd("highlight! Pmenu ctermbg=NONE guibg=NONE")
if not vim.g.zz.statusline then
  vim.cmd("\n          highlight! link StatusLine Normal\n          highlight! link StatusLineNC Normal\n         ")
else
end
if vim.g.zz.transparent then
  return vim.cmd("highlight! Normal ctermbg=NONE guibg=NONE\n            highlight! NormalFloat ctermbg=NONE guibg=NONE\n            highlight! EndOfBuffer ctermbg=NONE guibg=NONE\n            ")
else
  return nil
end
