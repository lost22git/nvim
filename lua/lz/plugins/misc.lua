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
local _6_
do
  local data = {{"th", "Left"}, {"tl", "Right"}, {"tk", "Up"}, {"tj", "Down"}, {"tsh", "SwapLeft"}, {"tsl", "SwapRight"}, {"tsk", "SwapUp"}, {"tsj", "SwapDown"}}
  local tbl_21_ = {}
  local i_22_ = 0
  for _, _8_ in ipairs(data) do
    local k = _8_[1]
    local v = _8_[2]
    local val_23_
    local _9_
    if vim.startswith(v, "Swap") then
      _9_ = "n"
    else
      _9_ = {"n", "v"}
    end
    val_23_ = {k, ("<Cmd>Treewalker " .. v .. "<CR>"), mode = _9_, desc = ("[treewalker] " .. v)}
    if (nil ~= val_23_) then
      i_22_ = (i_22_ + 1)
      tbl_21_[i_22_] = val_23_
    else
    end
  end
  _6_ = tbl_21_
end
return {{"lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {indent = {char = "\226\150\143"}}, keys = {{"<Leader>i", "<Cmd>IBLToggle<CR>", mode = {"n", "v"}, desc = "[IBL] Toggle"}}}, {"nvim-focus/focus.nvim", cmd = "FocusEnable", opts = {ui = {cursorline = false, signcolumn = false}}}, {"lost22git/true-zen.nvim", branch = "fix-by-lost", opts = {}, keys = {{"<Leader>za", "<Cmd>TZAtaraxis<CR>", desc = "[true-zen] TZAtaraxis"}, {"<Leader>zf", "<Cmd>TZFocus<CR>", desc = "[true-zen] TZFocus"}, {"<Leader>zm", "<Cmd>TZMinimalist<CR>", desc = "[true-zen] TZMinimalist"}, {"<Leader>zn", "<Cmd>TZNarrow<CR>", desc = "[true-zen] TZNarrow"}}}, {"s1n7ax/nvim-window-picker", opts = {hint = "floating-big-letter", filter_rules = {bo = {buftype = {}}}}, keys = {{"<Leader>w", _1_, mode = {"n", "v"}, desc = "[window-picker] Pick window"}}}, {"stevearc/quicker.nvim", ft = "qf", keys = {{"<Leader>q", _2_, desc = "[quicker] Toggle qflist"}, {"<Leader>l", _3_, desc = "[quicker] Toggle loclist"}}, opts = {keys = {{">", _4_, desc = "[quicker] Expand context"}, {"<", _5_, desc = "[quicker] Collapse context"}}}}, {"numToStr/FTerm.nvim", keys = {{"<M-3>", "<C-\\><C-n><Cmd>lua require(\"FTerm\").toggle()<CR>", mode = {"n", "v", "i", "t"}, noremap = true, desc = "[FTerm] Toggle"}}, opts = {ft = "FTerm", cmd = (vim.g.zz.shell or vim.o.shell), border = vim.o.winborder}}, {"EL-MASTOR/bufferlist.nvim", keys = {{"<Leader>b", "<Cmd>BufferList<CR>", desc = "[bufferlist] Open"}}, opts = {}}, {"mbbill/undotree", keys = {{"<Leader>u", "<CMD>UndotreeToggle<CR>", desc = "[undotree] Toggle"}}}, {"MagicDuck/grug-far.nvim", cmd = {"GrugFar", "GrugFarWithin"}, opts = {}}, {"aaronik/treewalker.nvim", opts = {highlight = true, highlight_duration = 300, highlight_group = "Visual"}, keys = _6_}, {"nvimdev/modeline.nvim", opts = {}, lazy = false}, {"mikavilpas/yazi.nvim", opts = {}}}
