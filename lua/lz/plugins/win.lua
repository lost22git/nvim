-- [nfnl] fnl/lz/plugins/win.fnl
local function _1_()
  return vim.api.nvim_set_current_win(require("window-picker").pick_window())
end
return {{"nvim-focus/focus.nvim", cmd = "FocusEnable", opts = {ui = {cursorline = false, signcolumn = false}}}, {"lost22git/true-zen.nvim", branch = "fix-by-lost", opts = {}, keys = {{"<Leader>za", "<Cmd>TZAtaraxis<CR>", desc = "[true-zen] TZAtaraxis"}, {"<Leader>zf", "<Cmd>TZFocus<CR>", desc = "[true-zen] TZFocus"}, {"<Leader>zm", "<Cmd>TZMinimalist<CR>", desc = "[true-zen] TZMinimalist"}, {"<Leader>zn", "<Cmd>TZNarrow<CR>", desc = "[true-zen] TZNarrow"}}}, {"s1n7ax/nvim-window-picker", opts = {hint = "floating-big-letter"}, keys = {{"<Leader>w", _1_, mode = {"n", "v"}, desc = "[window-picker] Pick window"}}}}
