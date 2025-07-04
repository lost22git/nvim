-- [nfnl] fnl/lz/plugins/edit.fnl
local _1_
do
  local data = {{"th", "Left"}, {"tl", "Right"}, {"tk", "Up"}, {"tj", "Down"}, {"tsh", "SwapLeft"}, {"tsl", "SwapRight"}, {"tsk", "SwapUp"}, {"tsj", "SwapDown"}}
  local tbl_21_ = {}
  local i_22_ = 0
  for _, _3_ in ipairs(data) do
    local k = _3_[1]
    local v = _3_[2]
    local val_23_
    local _4_
    if vim.startswith(v, "Swap") then
      _4_ = "n"
    else
      _4_ = {"n", "v"}
    end
    val_23_ = {k, ("<Cmd>Treewalker " .. v .. "<CR>"), mode = _4_, desc = ("[treewalker] " .. v)}
    if (nil ~= val_23_) then
      i_22_ = (i_22_ + 1)
      tbl_21_[i_22_] = val_23_
    else
    end
  end
  _1_ = tbl_21_
end
local _7_
do
  local tbl_16_ = {}
  for _, _8_ in ipairs({{"du", "raise_form"}, {"dU", "raise_element"}, {">D", "drag_pair_forwards"}, {"<D", "drag_pair_backwards"}, {">E", "drag_element_forwards"}, {"<E", "drag_element_backwards"}, {">F", "drag_form_forwards"}, {"<F", "drag_form_backwards"}}) do
    local k = _8_[1]
    local v = _8_[2]
    local k_17_, v_18_ = nil, nil
    local function _9_()
      return require("nvim-paredit").api[v]()
    end
    k_17_, v_18_ = k, {_9_, v}
    if ((k_17_ ~= nil) and (v_18_ ~= nil)) then
      tbl_16_[k_17_] = v_18_
    else
    end
  end
  _7_ = tbl_16_
end
local function _11_(...)
  local tbl_16_ = {}
  for _, _12_ in ipairs({{"<A", "inner_start"}, {">A", "inner_end"}}) do
    local k = _12_[1]
    local v = _12_[2]
    local k_17_, v_18_ = nil, nil
    local function _13_()
      local par = require("nvim-paredit")
      return par.cursor.place_cursor(par.wrap.wrap_enclosing_form_under_cursor("(", ")"), {placement = v, mode = "insert"})
    end
    k_17_, v_18_ = k, {_13_, ("Wrap form " .. v)}
    if ((k_17_ ~= nil) and (v_18_ ~= nil)) then
      tbl_16_[k_17_] = v_18_
    else
    end
  end
  return tbl_16_
end
local _15_
do
  local data = {{"s", "jump", {"n", "x", "o"}}, {"S", "treesitter", {"n", "x", "o"}}, {"r", "remote", "o"}, {"R", "treesitter_search", {"x", "o"}}, {"<c-s>", "toggle", "c"}}
  local tbl_21_ = {}
  local i_22_ = 0
  for _, _17_ in ipairs(data) do
    local k = _17_[1]
    local v = _17_[2]
    local m = _17_[3]
    local val_23_
    local function _18_()
      return require("flash")[v]()
    end
    val_23_ = {k, _18_, mode = m}
    if (nil ~= val_23_) then
      i_22_ = (i_22_ + 1)
      tbl_21_[i_22_] = val_23_
    else
    end
  end
  _15_ = tbl_21_
end
return {{"TheBlob42/houdini.nvim", event = {"InsertEnter", "CmdLineEnter", "TermEnter"}, opts = {timeout = 250, escape_sequences = {c = "<BS><BS><Esc>", V = false, v = false}}}, {"Wansmer/treesj", dependencies = {"nvim-treesitter/nvim-treesitter"}, opts = {use_default_keymaps = false}, keys = {{"<Leader>j", "<Cmd>TSJToggle<CR>", desc = "[treesj] Split/Join"}}}, {"aaronik/treewalker.nvim", opts = {highlight = true, highlight_duration = 300, highlight_group = "Visual"}, keys = _1_}, {"julienvincent/nvim-paredit", event = "VeryLazy", opts = {filetypes = {"clojure", "fennel", "janet"}, keys = vim.tbl_extend("error", _7_, _11_(...))}}, {"folke/flash.nvim", opts = {modes = {char = {enabled = false}}}, keys = _15_}, {"MagicDuck/grug-far.nvim", cmd = {"GrugFar", "GrugFarWithin"}, opts = {}}}
