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
  local tbl_21_ = {}
  for _, _8_ in ipairs({{"du", "raise_form"}, {"dU", "raise_element"}, {">)", "slurp_forwards"}, {">(", "barf_backwards"}, {"<)", "barf_forwards"}, {"<(", "slurp_backwards"}, {">D", "drag_pair_forwards"}, {"<D", "drag_pair_backwards"}, {">E", "drag_element_forwards"}, {"<E", "drag_element_backwards"}, {">F", "drag_form_forwards"}, {"<F", "drag_form_backwards"}}) do
    local k = _8_[1]
    local v = _8_[2]
    local k_22_, v_23_
    local function _9_()
      return require("nvim-paredit").api[v]()
    end
    k_22_, v_23_ = k, {_9_, v}
    if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
      tbl_21_[k_22_] = v_23_
    else
    end
  end
  _7_ = tbl_21_
end
local function _11_(...)
  local tbl_21_ = {}
  for _, _12_ in ipairs({{"<A", "inner_start"}, {">A", "inner_end"}}) do
    local k = _12_[1]
    local v = _12_[2]
    local k_22_, v_23_
    local function _13_()
      local par = require("nvim-paredit")
      return par.cursor.place_cursor(par.wrap.wrap_enclosing_form_under_cursor("(", ")"), {placement = v, mode = "insert"})
    end
    k_22_, v_23_ = k, {_13_, ("Wrap form " .. v)}
    if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
      tbl_21_[k_22_] = v_23_
    else
    end
  end
  return tbl_21_
end
local _15_
do
  local data = {{"<Leader>s", "jump", {"n", "x", "o"}}, {"<Leader>S", "treesitter", {"n", "x", "o"}}, {"r", "remote", "o"}, {"R", "treesitter_search", {"x", "o"}}, {"<c-s>", "toggle", "c"}}
  local tbl_26_ = {}
  local i_27_ = 0
  for _, _17_ in ipairs(data) do
    local k = _17_[1]
    local v = _17_[2]
    local m = _17_[3]
    local val_28_
    local function _18_()
      return require("flash")[v]()
    end
    val_28_ = {k, _18_, mode = m}
    if (nil ~= val_28_) then
      i_27_ = (i_27_ + 1)
      tbl_26_[i_27_] = val_28_
    else
    end
  end
  _15_ = tbl_26_
end
return {{"lost22git/highlight-visual.nvim", opts = {}, lazy = false}, {"TheBlob42/houdini.nvim", event = {"InsertEnter", "CmdLineEnter", "TermEnter"}, opts = {timeout = 250, escape_sequences = {c = "<BS><BS><Esc>", V = false, v = false}}}, {"Wansmer/treesj", dependencies = {"nvim-treesitter/nvim-treesitter"}, opts = {use_default_keymaps = false}, keys = {{"<Leader>j", "<Cmd>TSJToggle<CR>", desc = "[treesj] Split/Join"}}}, {"aaronik/treewalker.nvim", opts = {highlight = true, highlight_duration = 300, highlight_group = "Visual"}, keys = _1_}, {"julienvincent/nvim-paredit", event = "VeryLazy", opts = {filetypes = {"clojure", "fennel", "janet", "lisp"}, keys = vim.tbl_extend("error", _7_, _11_(...)), use_default_keys = false}}, {"folke/flash.nvim", opts = {modes = {char = {enabled = false}}}, keys = _15_}, {"MagicDuck/grug-far.nvim", cmd = {"GrugFar", "GrugFarWithin"}, opts = {}}, {"andrewferrier/debugprint.nvim", cmd = "DeleteDebugPrints", keys = {"g?"}, opts = {}}}
