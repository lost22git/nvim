-- [nfnl] fnl/core/vars.fnl
local zz_default
local _1_
if (vim.fn.has("win32") == 1) then
  _1_ = "pwsh"
else
  _1_ = nil
end
zz_default = {backdrop = 100, shell = _1_, statusline = false, transparent = false}
vim.g.zz = vim.tbl_deep_extend("force", zz_default, (vim.g.zz or {}))
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.markdown_fenced_languages = {"ts=typescript"}
vim.g.markdown_recommended_style = 0
return nil
