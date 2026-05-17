-- [nfnl] fnl/lz/plugins/win.fnl
local function _1_()
  return vim.api.nvim_set_current_win(require("window-picker").pick_window())
end
return {{"s1n7ax/nvim-window-picker", opts = {hint = "floating-big-letter"}, keys = {{"<Leader>w", _1_, mode = {"n", "v"}, desc = "[window-picker] Pick window"}}}}
