-- [nfnl] fnl/lz/plugins/list.fnl
local function _1_(_, opts)
  local _local_2_ = require("fzf-lua")
  local setup = _local_2_["setup"]
  local register_ui_select = _local_2_["register_ui_select"]
  setup(opts)
  return register_ui_select()
end
local _3_
do
  local data = {{"f", "builtin"}, {"F", "resume"}, {"f?", "helptags"}, {"f/", "search_history"}, {"f:", "command_history"}, {"f<Tab>", "tabs"}, {"fb", "buffers"}, {"fd", "lsp_document_diagnostics"}, {"fD", "lsp_workspace_diagnostics"}, {"fe", "oldfiles"}, {"ff", "files"}, {"fF", "lsp_finder"}, {"fg", "live_grep"}, {"fG", "live_grep resume=true"}, {"fh", "git_hunks"}, {"fi", "lsp_implementations"}, {"fk", "keymaps"}, {"fl", "blines"}, {"fr", "lsp_references"}, {"fs", "lsp_document_symbols"}, {"fz", "zoxide"}}
  local tbl_21_ = {}
  local i_22_ = 0
  for _, _5_ in pairs(data) do
    local k = _5_[1]
    local v = _5_[2]
    local val_23_ = {("<Leader>" .. k), ("<CMD>FzfLua " .. v .. "<CR>"), desc = ("[fzflua] " .. v)}
    if (nil ~= val_23_) then
      i_22_ = (i_22_ + 1)
      tbl_21_[i_22_] = val_23_
    else
    end
  end
  _3_ = tbl_21_
end
local function _7_()
  return require("quicker").toggle()
end
local function _8_()
  return require("quicker").toggle({loclist = true})
end
local function _9_()
  return require("quicker").expand({before = 2, after = 2, add_to_existing = true})
end
local function _10_()
  return require("quicker").collapse()
end
local _11_
do
  local data = {{"nd", "diagnostics"}, {"nD", "diagnostics workspace"}, {"ne", "watchtower"}, {"ns", "symbols"}, {"nt", "treesitter"}, {"nw", "workspace"}}
  local tbl_21_ = {}
  local i_22_ = 0
  for _, _13_ in pairs(data) do
    local k = _13_[1]
    local v = _13_[2]
    local val_23_ = {("<Leader>" .. k), ("<CMD>Namu " .. v .. "<CR>"), desc = ("[namu] " .. v)}
    if (nil ~= val_23_) then
      i_22_ = (i_22_ + 1)
      tbl_21_[i_22_] = val_23_
    else
    end
  end
  _11_ = tbl_21_
end
return {{"ibhagwan/fzf-lua", cmd = "FzfLua", opts = {fzf_colors = true, winopts = {backdrop = vim.g.zz.backdrop, preview = {hidden = true}}}, config = _1_, keys = _3_}, {"mbbill/undotree", keys = {{"<Leader>u", "<CMD>UndotreeToggle<CR>", desc = "[undotree] Toggle"}}}, {"stevearc/aerial.nvim", opts = {}, keys = {{"<Leader>O", "<Cmd>AerialToggle<Cr>", desc = "[aerial] toggle"}}}, {"stevearc/quicker.nvim", ft = "qf", keys = {{"<Leader>q", _7_, desc = "[quicker] Toggle qflist"}, {"<Leader>l", _8_, desc = "[quicker] Toggle loclist"}}, opts = {keys = {{">", _9_, desc = "[quicker] Expand context"}, {"<", _10_, desc = "[quicker] Collapse context"}}}}, {"mikavilpas/yazi.nvim", cmd = "Yazi", opts = {}}, {"bassamsdata/namu.nvim", cmd = "Namu", opts = {global = {movement = {next = {"<M-j>", "<DOWN>"}, previous = {"<M-k>", "<UP>"}, close = {"<C-c>", "<Esc>"}}, multiselect = {enabled = true, selected_icon = "\226\156\147", keymaps = {toggle = "<Tab>", untoggle = "<S-Tab>", select_all = "<M-a>", clear_all = "<M-x>"}}, custom_keymaps = {yank = {keys = {"<M-y>"}, desc = "Yank symbol text"}, delete = {keys = {"M-d"}, desc = "Delete symbol text"}}}, namu_symbols = {enable = true, options = {}}, ui_select = {enable = false}}, keys = _11_}, {"A7Lavinraj/fyler.nvim", cmd = "Fyler", opts = {}}, {"alex-popov-tech/store.nvim", cmd = "Store", opts = {width = 1, height = 1}}}
