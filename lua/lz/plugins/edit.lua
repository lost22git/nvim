-- [nfnl] fnl/lz/plugins/edit.fnl
local _1_
do
  local data = {{"th", "Left"}, {"tl", "Right"}, {"tk", "Up"}, {"tj", "Down"}, {"tsh", "SwapLeft"}, {"tsl", "SwapRight"}, {"tsk", "SwapUp"}, {"tsj", "SwapDown"}}
  local tbl_26_ = {}
  local i_27_ = 0
  for _, _3_ in ipairs(data) do
    local k = _3_[1]
    local v = _3_[2]
    local val_28_
    local _4_
    if vim.startswith(v, "Swap") then
      _4_ = "n"
    else
      _4_ = {"n", "v"}
    end
    val_28_ = {k, ("<Cmd>Treewalker " .. v .. "<CR>"), mode = _4_, desc = ("[treewalker] " .. v)}
    if (nil ~= val_28_) then
      i_27_ = (i_27_ + 1)
      tbl_26_[i_27_] = val_28_
    else
    end
  end
  _1_ = tbl_26_
end
local _7_
do
  local data = {{"<Leader>s", "jump", {"n", "x", "o"}}, {"<Leader>S", "treesitter", {"n", "x", "o"}}, {"r", "remote", "o"}, {"R", "treesitter_search", {"x", "o"}}, {"<c-s>", "toggle", "c"}}
  local tbl_26_ = {}
  local i_27_ = 0
  for _, _9_ in ipairs(data) do
    local k = _9_[1]
    local v = _9_[2]
    local m = _9_[3]
    local val_28_
    local function _10_()
      return require("flash")[v]()
    end
    val_28_ = {k, _10_, mode = m}
    if (nil ~= val_28_) then
      i_27_ = (i_27_ + 1)
      tbl_26_[i_27_] = val_28_
    else
    end
  end
  _7_ = tbl_26_
end
return {{"lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {indent = {char = "\226\150\143"}}, keys = {{"<Tab>i", "<Cmd>IBLToggle<CR>", mode = {"n", "v"}, desc = "[IBL] Toggle"}}}, {"mbbill/undotree", keys = {{"<Leader>u", "<CMD>UndotreeToggle<CR>", desc = "[undotree] Toggle"}}}, {"Wansmer/treesj", opts = {use_default_keymaps = false}, keys = {{"<Leader>j", "<Cmd>TSJToggle<CR>", desc = "[treesj] SplitJoin"}}}, {"aaronik/treewalker.nvim", opts = {highlight = true, highlight_duration = 300, highlight_group = "Visual"}, keys = _1_}, {"folke/flash.nvim", opts = {modes = {char = {enabled = false}}}, keys = _7_}}
