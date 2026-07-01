-- [nfnl] fnl/core/hls.fnl
local function do_hls()
  vim.cmd("highlight! link FloatBorder Normal\n            highlight! link BlinkCmpDocBorder FloatBorder\n            highlight! link BlinkCmpMenuBorder FloatBorder\n            highlight! link BlinkCmpSignatureHelpBorder FloatBorder\n            ")
  if vim.g.zz.transparent then
    return vim.cmd("highlight! Pmenu ctermbg=NONE guibg=NONE\n              highlight! Normal ctermbg=NONE guibg=NONE\n              highlight! NormalNC ctermbg=NONE guibg=NONE\n              highlight! NormalFloat ctermbg=NONE guibg=NONE\n              highlight! EndOfBuffer ctermbg=NONE guibg=NONE\n              ")
  else
    return nil
  end
end
local function _2_()
  return do_hls()
end
vim.api.nvim_create_autocmd("ColorScheme", {callback = _2_})
return do_hls()
