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
    vim.g["conjure#client#scheme#stdio#command"] = "chicken-csi -:c -R apropos"
    vim.g["conjure#client#scheme#stdio#prompt_pattern"] = "\n-#;%d-> "
    vim.g["conjure#client#scheme#stdio#value_prefix_pattern"] = false
    return nil
  end
  local function configure_nodejs()
    vim.g["conjure#client#javascript#stdio#typescript_cmd"] = "ts-node"
    vim.g["conjure#client#javascript#stdio#javascript_cmd"] = "node --experimental-repl-await"
    vim.g["conjure#client#javascript#stdio#args"] = "-i"
    return nil
  end
  local function configure_deno()
    vim.g["conjure#client#javascript#stdio#typescript_cmd"] = "deno"
    vim.g["conjure#client#javascript#stdio#javascript_cmd"] = "deno"
    vim.g["conjure#client#javascript#stdio#args"] = "repl"
    return nil
  end
  local function conjure_change(ft, repl)
    if (ft == "scheme") then
      vim.cmd("ConjureSchemeStop")
    elseif ((ft == "javascript") or (ft == "typescript")) then
      vim.cmd("ConjureJavascriptStop")
    else
    end
    do
      local case_3_, case_4_ = ft, repl
      if ((case_3_ == "scheme") and (case_4_ == "chez")) then
        configure_chez_scheme()
      elseif ((case_3_ == "scheme") and (case_4_ == "chicken")) then
        configure_chicken_scheme()
      elseif ((case_3_ == "javascript") and (case_4_ == "nodejs")) then
        configure_nodejs()
      elseif ((case_3_ == "javascript") and (case_4_ == "deno")) then
        configure_deno()
      elseif ((case_3_ == "typescript") and (case_4_ == "nodejs")) then
        configure_nodejs()
      elseif ((case_3_ == "typescript") and (case_4_ == "deno")) then
        configure_deno()
      else
      end
    end
    if (ft == "scheme") then
      return vim.cmd("ConjureSchemeStart")
    elseif ((ft == "javascript") or (ft == "typescript")) then
      return vim.cmd("ConjureJavascriptStart")
    else
      return nil
    end
  end
  local function conjure_change_arg_cmp(ft)
    if (ft == "scheme") then
      return {"chez", "chicken"}
    elseif (ft == "javascript") then
      return {"nodejs", "deno"}
    elseif (ft == "typescript") then
      return {"nodejs", "deno"}
    else
      return nil
    end
  end
  configure_chicken_scheme()
  configure_nodejs()
  local function _9_(_8_)
    local buf = _8_.buf
    local ft = vim.bo[buf].filetype
    local function _12_(_10_)
      local _arg_11_ = _10_.fargs
      local repl = _arg_11_[1]
      return conjure_change(ft, repl)
    end
    local function _13_()
      return conjure_change_arg_cmp(ft)
    end
    return vim.api.nvim_buf_create_user_command(buf, "ConjureChange", _12_, {nargs = 1, complete = _13_})
  end
  vim.api.nvim_create_autocmd("FileType", {desc = "create `ConjureChange` usercmd to change REPL", pattern = {"scheme", "javascript", "typescript"}, callback = _9_})
  local function _15_(_14_)
    local bufid = _14_.buf
    local _local_16_ = require("core.utils")
    local disable_diagnostic = _local_16_.disable_diagnostic
    local create_keymaps_for_goto_entry = _local_16_.create_keymaps_for_goto_entry
    disable_diagnostic()
    return create_keymaps_for_goto_entry("\\v^(;|--|#|\\/\\/) -+$", "[e", "]e", "conjure_log", bufid)
  end
  return vim.api.nvim_create_autocmd("BufWinEnter", {desc = "create keymaps for conjure log", pattern = {"conjure-log-*"}, callback = _15_})
end
local function _17_(_, opts)
  require("repl").setup(opts)
  local ftypes = vim.tbl_keys(opts.filetype_commands)
  local function create_keymaps(bufid)
    vim.keymap.set("n", "<Leader>ee", "<Plug>(ReplSendLine)", {buffer = bufid, desc = "[repl] SendLine"})
    return vim.keymap.set("v", "<Leader>ee", "<Plug>(ReplSendVisual)", {buffer = bufid, desc = "[repl] SendVisual"})
  end
  local function _18_(_241)
    return create_keymaps(_241.buf)
  end
  vim.api.nvim_create_autocmd("FileType", {pattern = ftypes, callback = _18_})
  if vim.list_contains(ftypes, vim.bo.filetype) then
    return create_keymaps(0)
  else
    return nil
  end
end
return {{"Olical/conjure", cmd = "ConjureConnect", event = "VeryLazy", init = _1_}, {"pappasam/nvim-repl", cmd = "Repl", opts = {filetype_commands = {arturo = {cmd = "arturo --repl"}, basilisp = {cmd = "basilisp repl"}, crystal = {cmd = "crystal i"}, elixir = {cmd = "iex"}, flix = {cmd = "flix repl"}, haskell = {cmd = "ghci"}, java = {cmd = "jshell"}, koka = {cmd = "koka"}, kotlin = {cmd = "rlwrap kotlin -repl"}, lfe = {cmd = "lfe"}, lisp = {cmd = "rlwrap sbcl"}, nim = {cmd = "inim"}, ocaml = {cmd = "rlwrap ocaml"}, racket = {cmd = "rlwrap racket -i"}, raku = {cmd = "rlwrap raku"}, roc = {cmd = "roc repl"}, swift = {cmd = "swift repl"}, typescript = {cmd = "deno repl"}, v = {cmd = "v repl"}}}, config = _17_}}
