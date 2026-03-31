-- [nfnl] fnl/core/ts.fnl
local function _2_(_1_)
  local buf = _1_.buf
  pcall(vim.treesitter.start, buf)
  return nil
end
return vim.api.nvim_create_autocmd("Filetype", {desc = "[TS] vim.treesitter.start()", callback = _2_})
