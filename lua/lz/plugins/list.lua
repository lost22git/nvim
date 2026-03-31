-- [nfnl] fnl/lz/plugins/list.fnl
local function _1_()
  return require("quicker").toggle()
end
local function _2_()
  return require("quicker").toggle({loclist = true})
end
local function _3_()
  return require("quicker").expand({before = 2, after = 2, add_to_existing = true})
end
local function _4_()
  return require("quicker").collapse()
end
local function _5_(_, opts)
  local _local_6_ = require("fzf-lua")
  local setup = _local_6_.setup
  local register_ui_select = _local_6_.register_ui_select
  setup(opts)
  return register_ui_select()
end
local _7_
do
  local data = {{"f", "builtin"}, {"F", "resume"}, {"f?", "helptags"}, {"f/", "search_history"}, {"f:", "command_history"}, {"f<Tab>", "tabs"}, {"fb", "buffers"}, {"fd", "lsp_document_diagnostics"}, {"fD", "lsp_workspace_diagnostics"}, {"fe", "oldfiles"}, {"ff", "files"}, {"fF", "lsp_finder"}, {"fg", "live_grep"}, {"fG", "live_grep resume=true"}, {"fh", "git_hunks"}, {"fi", "lsp_implementations"}, {"fk", "keymaps"}, {"fl", "blines"}, {"fr", "lsp_references"}, {"fs", "lsp_document_symbols"}, {"fz", "zoxide"}}
  local tbl_26_ = {}
  local i_27_ = 0
  for _, _9_ in pairs(data) do
    local k = _9_[1]
    local v = _9_[2]
    local val_28_ = {("<Leader>" .. k), ("<CMD>FzfLua " .. v .. "<CR>"), desc = ("[fzflua] " .. v)}
    if (nil ~= val_28_) then
      i_27_ = (i_27_ + 1)
      tbl_26_[i_27_] = val_28_
    else
    end
  end
  _7_ = tbl_26_
end
local _11_
do
  local data = {{"nd", "diagnostics"}, {"nD", "diagnostics workspace"}, {"ns", "symbols"}, {"nS", "treesitter"}, {"nw", "watchtower"}, {"nW", "workspace"}}
  local tbl_26_ = {}
  local i_27_ = 0
  for _, _13_ in pairs(data) do
    local k = _13_[1]
    local v = _13_[2]
    local val_28_ = {("<Leader>" .. k), ("<CMD>Namu " .. v .. "<CR>"), desc = ("[namu] " .. v)}
    if (nil ~= val_28_) then
      i_27_ = (i_27_ + 1)
      tbl_26_[i_27_] = val_28_
    else
    end
  end
  _11_ = tbl_26_
end
return {{"mikavilpas/yazi.nvim", cmd = "Yazi", opts = {}}, {"stevearc/aerial.nvim", opts = {}, keys = {{"<Leader>O", "<Cmd>AerialToggle<Cr>", desc = "[aerial] toggle"}}}, {"stevearc/quicker.nvim", ft = "qf", keys = {{"<Leader>q", _1_, desc = "[quicker] Toggle qflist"}, {"<Leader>l", _2_, desc = "[quicker] Toggle loclist"}}, opts = {keys = {{">", _3_, desc = "[quicker] Expand context"}, {"<", _4_, desc = "[quicker] Collapse context"}}}}, {"ibhagwan/fzf-lua", opts = {fzf_colors = true, winopts = {backdrop = vim.g.zz.backdrop, preview = {hidden = true}}}, config = _5_, keys = _7_}, {"bassamsdata/namu.nvim", cmd = "Namu", opts = {global = {movement = {next = {"<M-j>", "<DOWN>"}, previous = {"<M-k>", "<UP>"}, close = {"<C-c>", "<Esc>"}}, multiselect = {enabled = true, selected_icon = "\226\156\147", keymaps = {toggle = "<Tab>", untoggle = "<S-Tab>", select_all = "<M-a>", clear_all = "<M-x>"}}, custom_keymaps = {yank = {keys = {"<M-y>"}}, delete = {keys = {"M-d"}}}}, namu_symbols = {enable = true, options = {}}, ui_select = {enable = false}}, keys = _11_}}
