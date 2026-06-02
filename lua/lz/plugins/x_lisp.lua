-- [nfnl] fnl/lz/plugins/x_lisp.fnl
local _1_
do
  local data = {{"du", "raise_form"}, {"dU", "raise_element"}, {">)", "slurp_forwards"}, {">(", "barf_backwards"}, {"<)", "barf_forwards"}, {"<(", "slurp_backwards"}, {">D", "drag_pair_forwards"}, {"<D", "drag_pair_backwards"}, {">E", "drag_element_forwards"}, {"<E", "drag_element_backwards"}, {">F", "drag_form_forwards"}, {"<F", "drag_form_backwards"}, {"E", "move_to_next_element_tail"}, {"W", "move_to_next_element_head"}, {"B", "move_to_prev_element_head"}, {"gE", "move_to_prev_element_tail"}, {"(", "move_to_parent_form_start"}, {")", "move_to_parent_form_end"}, {"T", "move_to_top_level_form_head"}}
  local tbl_21_ = {}
  for _, _3_ in ipairs(data) do
    local k = _3_[1]
    local v = _3_[2]
    local k_22_, v_23_
    local function _4_()
      return require("nvim-paredit").api[v]()
    end
    k_22_, v_23_ = k, {_4_, ("[paredit] " .. v)}
    if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
      tbl_21_[k_22_] = v_23_
    else
    end
  end
  _1_ = tbl_21_
end
local function _6_(...)
  local data = {{"<A", "inner_start"}, {">A", "inner_end"}}
  local tbl_21_ = {}
  for _, _7_ in ipairs(data) do
    local k = _7_[1]
    local v = _7_[2]
    local k_22_, v_23_
    local function _8_()
      local par = require("nvim-paredit")
      return par.cursor.place_cursor(par.wrap.wrap_enclosing_form_under_cursor("(", ")"), {placement = v, mode = "insert"})
    end
    k_22_, v_23_ = k, {_8_, ("[paredit] Wrap form " .. v)}
    if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
      tbl_21_[k_22_] = v_23_
    else
    end
  end
  return tbl_21_
end
return {{"lost22git/nvim-paredit", branch = "add-racket-lang", ft = {"clojure", "fennel", "janet", "lisp", "scheme", "racket"}, opts = {keys = vim.tbl_extend("error", _1_, _6_(...)), use_default_keys = false}}}
