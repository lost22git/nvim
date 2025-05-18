-- [nfnl] fnl/core/hls.fnl
vim.cmd("highlight Pmenu ctermbg=NONE guibg=NONE")
if vim.g.zz.transparent then
  return vim.cmd("highlight Normal ctermbg=NONE guibg=NONE\n            highlight NormalFloat ctermbg=NONE guibg=NONE\n            highlight EndOfBuffer ctermbg=NONE guibg=NONE\n            ")
else
  return nil
end
