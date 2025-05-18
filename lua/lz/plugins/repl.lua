-- [nfnl] fnl/lz/plugins/repl.fnl
local function _1_()
  vim.g["conjure#highlight#enabled"] = true
  vim.g["conjure#extract#tree_sitter#enabled"] = true
  vim.g["conjure#log#jump_to_latest#enabled"] = true
  vim.g["conjure#mapping#doc_word"] = {"<LocalLeader>k"}
  vim.g["conjure#mapping#eval_visual"] = {"<LocalLeader>ee"}
  vim.g["conjure#mapping#eval_replace_form"] = {"<LocalLeader>es"}
  vim.g["conjure#mapping#eval_previous"] = {"<LocalLeader>E"}
  local function _2_(ev)
    local bufid = ev.buf
    local _local_3_ = require("core.utils")
    local disable_diagnostic = _local_3_["disable_diagnostic"]
    local p = "\\v^(;|--|#) -+$"
    vim.keymap.set({"n", "v"}, "[e", string.format("<Cmd>call search(\"%s\" \"bw\")<CR>", p), {buffer = bufid, desc = "[conjure] Goto prev log"})
    return vim.keymap.set({"n", "v"}, "]e", string.format("<Cmd>call search(\"%s\" \"w\")<CR>", p), {buffer = bufid, desc = "[conjure] Goto next log"})
  end
  return vim.api.nvim_create_autocmd("BufWinEnter", {pattern = {"conjure-log-*"}, callback = _2_})
end
local function _4_(_, opts)
  require("repl").setup(opts)
  local ftypes = vim.tbl_keys(opts.filetype_commands)
  local function create_keymaps(bufid)
    vim.keymap.set("n", "<Leader>ee", "<Plug>(ReplSendLine)", {buffer = bufid, desc = "[repl] SendLine"})
    return vim.keymap.set("v", "<Leader>ee", "<Plug>(ReplSendVisual)", {buffer = bufid, desc = "[repl] SendVisual"})
  end
  local function _5_(_241)
    return create_keymaps(_241.buf)
  end
  vim.api.nvim_create_autocmd("FileType", {pattern = ftypes, callback = _5_})
  if vim.tbl_contains(ftypes, vim.bo.filetype) then
    return create_keymaps(0)
  else
    return nil
  end
end
return {{"Olical/conjure", cmd = "ConjureConnect", ft = {"lua", "fennel", "clojure", "janet", "racket"}, init = _1_}, {"pappasam/nvim-repl", cmd = "Repl", opts = {filetype_commands = {crystal = {cmd = "crystal i"}, elixir = {cmd = "iex"}, java = {cmd = "jshell"}, lfe = {cmd = "lfe"}, nim = {cmd = "inim"}, raku = {cmd = "rlwrap raku"}, swift = {cmd = "swift repl"}}}, config = _4_}}
