-- [nfnl] fnl/core/hls.fnl
local function do_hls()
  vim.cmd("highlight! Pmenu ctermbg=NONE guibg=NONE\n            highlight! link FloatBorder Normal\n            highlight! link BlinkCmpDocBorder FloatBorder\n            highlight! link BlinkCmpMenuBorder FloatBorder\n            highlight! link BlinkCmpSignatureHelpBorder FloatBorder\n            ")
  if not vim.g.zz.statusline then
    vim.cmd("highlight! link StatusLine Normal\n              highlight! link StatusLineNC Normal\n             ")
  else
  end
  if vim.g.zz.transparent then
    return vim.cmd("highlight! Normal ctermbg=NONE guibg=NONE\n              highlight! NormalNC ctermbg=NONE guibg=NONE\n              highlight! NormalFloat ctermbg=NONE guibg=NONE\n              highlight! EndOfBuffer ctermbg=NONE guibg=NONE\n              ")
  else
    return nil
  end
end
local function _3_()
  return do_hls()
end
vim.api.nvim_create_autocmd("ColorScheme", {callback = _3_})
return do_hls()
