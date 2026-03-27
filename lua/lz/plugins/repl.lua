-- [nfnl] fnl/lz/plugins/repl.fnl
local function _1_()
  vim.g["conjure#highlight#enabled"] = true
  vim.g["conjure#extract#tree_sitter#enabled"] = true
  vim.g["conjure#log#jump_to_latest#enabled"] = true
  vim.g["conjure#mapping#doc_word"] = {"<LocalLeader>k"}
  vim.g["conjure#mapping#eval_visual"] = {"<LocalLeader>ee"}
  vim.g["conjure#mapping#eval_previous"] = {"<LocalLeader>E"}
  local function configure_chez_scheme()
    vim.g["conjure#client#scheme#stdio#command"] = "petite"
    vim.g["conjure#client#scheme#stdio#prompt_pattern"] = "> $?"
    vim.g["conjure#client#scheme#stdio#value_prefix_pattern"] = false
    return nil
  end
  local function configure_chicken_scheme()
    vim.g["conjure#client#scheme#stdio#command"] = "chicken-csi -:c"
    vim.g["conjure#client#scheme#stdio#prompt_pattern"] = "\n-#;%d-> "
    vim.g["conjure#client#scheme#stdio#value_prefix_pattern"] = false
    return nil
  end
  local function change_scheme(lang)
    vim.cmd("ConjureSchemeStop")
    if (lang == "chez") then
      configure_chez_scheme()
    elseif (lang == "chicken") then
      configure_chicken_scheme()
    else
    end
    return vim.cmd("ConjureSchemeStart")
  end
  configure_chicken_scheme()
  local function _3_(_241)
    local function _6_(_4_)
      local _arg_5_ = _4_.fargs
      local lang = _arg_5_[1]
      return change_scheme(lang)
    end
    local function _7_()
      return {"chez", "chicken"}
    end
    return vim.api.nvim_buf_create_user_command(_241.buf, "ConjureSchemeChange", _6_, {nargs = 1, complete = _7_})
  end
  vim.api.nvim_create_autocmd("FileType", {desc = "create `ConjureSchemeChange` usercmd to change conjure repl for Scheme", pattern = "scheme", callback = _3_})
  local function _9_(_8_)
    local bufid = _8_.buf
    local _local_10_ = require("core.utils")
    local disable_diagnostic = _local_10_.disable_diagnostic
    local create_keymaps_for_goto_entry = _local_10_.create_keymaps_for_goto_entry
    disable_diagnostic()
    return create_keymaps_for_goto_entry("\\v^(;|--|#|\\/\\/) -+$", "[e", "]e", "conjure_log", bufid)
  end
  return vim.api.nvim_create_autocmd("BufWinEnter", {desc = "create keymaps for conjure log", pattern = {"conjure-log-*"}, callback = _9_})
end
local function _11_(_, opts)
  require("repl").setup(opts)
  local ftypes = vim.tbl_keys(opts.filetype_commands)
  local function create_keymaps(bufid)
    vim.keymap.set("n", "<Leader>ee", "<Plug>(ReplSendLine)", {buffer = bufid, desc = "[repl] SendLine"})
    return vim.keymap.set("v", "<Leader>ee", "<Plug>(ReplSendVisual)", {buffer = bufid, desc = "[repl] SendVisual"})
  end
  local function _12_(_241)
    return create_keymaps(_241.buf)
  end
  vim.api.nvim_create_autocmd("FileType", {pattern = ftypes, callback = _12_})
  if vim.list_contains(ftypes, vim.bo.filetype) then
    return create_keymaps(0)
  else
    return nil
  end
end
return {{"Olical/conjure", cmd = "ConjureConnect", event = "VeryLazy", init = _1_}, {"pappasam/nvim-repl", cmd = "Repl", opts = {filetype_commands = {arturo = {cmd = "arturo --repl"}, basilisp = {cmd = "basilisp repl"}, crystal = {cmd = "crystal i"}, elixir = {cmd = "iex"}, flix = {cmd = "flix repl"}, haskell = {cmd = "ghci"}, java = {cmd = "jshell"}, kotlin = {cmd = "rlwrap kotlin -repl"}, lfe = {cmd = "lfe"}, nim = {cmd = "inim"}, racket = {cmd = "rlwrap racket -i"}, raku = {cmd = "rlwrap raku"}, roc = {cmd = "roc repl"}, lisp = {cmd = "rlwrap sbcl"}, swift = {cmd = "swift repl"}, typescript = {cmd = "deno repl"}, v = {cmd = "v repl"}}}, config = _11_}}
