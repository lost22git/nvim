-- [nfnl] fnl/lz/plugins/repl.fnl
local function _1_()
  vim.g["conjure#highlight#enabled"] = true
  vim.g["conjure#extract#tree_sitter#enabled"] = true
  vim.g["conjure#log#jump_to_latest#enabled"] = true
  vim.g["conjure#mapping#doc_word"] = {"<LocalLeader>k"}
  vim.g["conjure#mapping#eval_visual"] = {"<LocalLeader>ee"}
  vim.g["conjure#mapping#eval_previous"] = {"<LocalLeader>E"}
  vim.g["conjure#client#scheme#stdio#command"] = "petite"
  vim.g["conjure#client#scheme#stdio#prompt_pattern"] = "> $?"
  local function _3_(_2_)
    local bufid = _2_.buf
    local _local_4_ = require("core.utils")
    local disable_diagnostic = _local_4_.disable_diagnostic
    local create_keymaps_for_goto_entry = _local_4_.create_keymaps_for_goto_entry
    disable_diagnostic()
    return create_keymaps_for_goto_entry("\\v^(;|--|#|\\/\\/) -+$", "[e", "]e", "conjure_log", bufid)
  end
  return vim.api.nvim_create_autocmd("BufWinEnter", {pattern = {"conjure-log-*"}, callback = _3_})
end
local function _5_(_, opts)
  require("repl").setup(opts)
  local ftypes = vim.tbl_keys(opts.filetype_commands)
  local function create_keymaps(bufid)
    vim.keymap.set("n", "<Leader>ee", "<Plug>(ReplSendLine)", {buffer = bufid, desc = "[repl] SendLine"})
    return vim.keymap.set("v", "<Leader>ee", "<Plug>(ReplSendVisual)", {buffer = bufid, desc = "[repl] SendVisual"})
  end
  local function _6_(_241)
    return create_keymaps(_241.buf)
  end
  vim.api.nvim_create_autocmd("FileType", {pattern = ftypes, callback = _6_})
  if vim.list_contains(ftypes, vim.bo.filetype) then
    return create_keymaps(0)
  else
    return nil
  end
end
return {{"Olical/conjure", cmd = "ConjureConnect", event = "VeryLazy", init = _1_}, {"pappasam/nvim-repl", cmd = "Repl", opts = {filetype_commands = {arturo = {cmd = "arturo --repl"}, crystal = {cmd = "crystal i"}, elixir = {cmd = "iex"}, flix = {cmd = "flix repl"}, java = {cmd = "jshell"}, kotlin = {cmd = "rlwrap kotlin -repl"}, lfe = {cmd = "lfe"}, nim = {cmd = "inim"}, racket = {cmd = "rlwrap racket -i"}, raku = {cmd = "rlwrap raku"}, roc = {cmd = "roc repl"}, lisp = {cmd = "rlwrap sbcl"}, swift = {cmd = "swift repl"}, typescript = {cmd = "deno repl"}, v = {cmd = "v repl"}}}, config = _5_}}
