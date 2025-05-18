-- [nfnl] fnl/lz/plugins/misc.fnl
local function _1_()
  return vim.api.nvim_set_current_win(require("window-picker").pick_window())
end
local function _2_()
  return require("quicker").toggle()
end
local function _3_()
  return require("quicker").toggle({loclist = true})
end
local function _4_()
  return require("quicker").expand({before = 2, after = 2, add_to_existing = true})
end
local function _5_()
  return require("quicker").collapse()
end
return {{"lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {indent = {char = "\226\150\143"}}, keys = {{"<Leader>i", "<Cmd>IBLToggle<CR>", mode = {"n", "v"}, desc = "[IBL] Toggle"}}}, {"nvim-focus/focus.nvim", cmd = "FocusEnable", opts = {ui = {cursorline = false, signcolumn = false}}}, {"lost22git/true-zen.nvim", branch = "fix-by-lost", opts = {}, keys = {{"<Leader>za", "<Cmd>TZAtaraxis<CR>", desc = "[true-zen] TZAtaraxis"}, {"<Leader>zf", "<Cmd>TZFocus<CR>", desc = "[true-zen] TZFocus"}, {"<Leader>zm", "<Cmd>TZMinimalist<CR>", desc = "[true-zen] TZMinimalist"}, {"<Leader>zn", "<Cmd>TZNarrow<CR>", desc = "[true-zen] TZNarrow"}}}, {"s1n7ax/nvim-window-picker", opts = {hint = "floating-big-letter", filter_rules = {bo = {buftype = {}}}}, keys = {{"<Leader>w", _1_, mode = {"n", "v"}, desc = "[window-picker] Pick window"}}}, {"stevearc/quicker.nvim", ft = "qf", keys = {{"<Leader>q", _2_, desc = "[quicker] Toggle qflist"}, {"<Leader>l", _3_, desc = "[quicker] Toggle loclist"}}, opts = {keys = {{">", _4_, desc = "[quicker] Expand context"}, {"<", _5_, desc = "[quicker] Collapse context"}}}}, {"numToStr/FTerm.nvim", keys = {{"<M-3>", "<C-\\><C-n><Cmd>lua require(\"FTerm\").toggle()<CR>", mode = {"n", "v", "i", "t"}, noremap = true, desc = "[FTerm] Toggle"}}, opts = {ft = "FTerm", cmd = (vim.g.zz.shell or vim.o.shell), border = vim.o.winborder}}}
