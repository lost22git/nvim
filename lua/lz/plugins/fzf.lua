-- [nfnl] fnl/lz/plugins/fzf.fnl
local _1_
do
  local data = {{"f", "builtin"}, {"F", "resume"}, {"f?", "helptags"}, {"f/", "search_history"}, {"f:", "command_history"}, {"f<Tab>", "tabs"}, {"fb", "buffers"}, {"fd", "lsp_document_diagnostics"}, {"fD", "lsp_workspace_diagnostics"}, {"fe", "oldfiles"}, {"ff", "files"}, {"fg", "lsp_finder"}, {"fh", "git_hunks"}, {"fi", "lsp_implementations"}, {"fk", "keymaps"}, {"fO", "lsp_document_symbols"}, {"fr", "lsp_references"}, {"fs", "live_grep"}, {"fz", "zoxide"}}
  local tbl_21_ = {}
  local i_22_ = 0
  for _, _3_ in pairs(data) do
    local k = _3_[1]
    local v = _3_[2]
    local val_23_ = {("<Leader>" .. k), ("<CMD>FzfLua " .. v .. "<CR>"), desc = ("[fzflua] " .. v)}
    if (nil ~= val_23_) then
      i_22_ = (i_22_ + 1)
      tbl_21_[i_22_] = val_23_
    else
    end
  end
  _1_ = tbl_21_
end
return {"ibhagwan/fzf-lua", cmd = "FzfLua", opts = {fzf_colors = true, winopts = {backdrop = vim.g.zz.backdrop, preview = {hidden = true}}}, keys = _1_}
