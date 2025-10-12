-- [nfnl] fnl/core/utils.fnl
local M = {}
M.on_gui = function()
  return (vim.g.neovide or vim.g.fvim_loaded or vim.g.vscode)
end
M.on_v_modes = function()
  local v_block_mode = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)
  local v_modes = {"v", "V", v_block_mode}
  return vim.list_contains(v_modes, vim.fn.mode())
end
M.disable_diagnostic = function(bufid)
  if vim.diagnostic.is_enabled({bufnr = bufid}) then
    return pcall(vim.diagnostic.enable, false, {bufnr = bufid})
  else
    return nil
  end
end
M.get_flutter_path = function()
  local path = vim.fn.exepath("flutter")
  if (vim.fn.has("win32") == 1) then
    return (path .. ".bat")
  else
    return path
  end
end
M.get_mason_path = function()
  return (vim.fn.stdpath("data") .. "/mason")
end
M.lsp_server_package_path = function(name)
  return (M.get_mason_path() .. "/packages/" .. name)
end
local function find_lsp_server_from_mason(name)
  local path = (M.get_mason_path() .. "/bin/" .. name)
  if (vim.fn.has("win32") == 1) then
    path = (path .. ".cmd")
  else
  end
  if (1 == vim.fn.executable(path)) then
    return path
  else
    return nil
  end
end
local function find_lsp_server_from_env_path(name)
  local path = vim.fn.exepath(name)
  if (path == "") then
    path = nil
  else
  end
  local and_6_ = path
  if and_6_ then
    and_6_ = (vim.fn.has("win32") == 1)
  end
  if and_6_ then
    local _8_
    do
      local t_7_ = vim.fn.split(vim.fs.basename(path), "\\.")
      if (nil ~= t_7_) then
        t_7_ = t_7_[2]
      else
      end
      _8_ = t_7_
    end
    and_6_ = not _8_
  end
  if and_6_ then
    path = (path .. ".cmd")
  else
  end
  return path
end
M.lsp_server_path = function(name)
  return (find_lsp_server_from_mason(name) or find_lsp_server_from_env_path(name))
end
M.lsp_with_server = function(name, f)
  local case_11_ = M.lsp_server_path(name)
  if (nil ~= case_11_) then
    local path = case_11_
    return f(path)
  else
    return nil
  end
end
M.lsp_capabilities = function()
  local cmp = require("blink.cmp")
  local opts = {textDocument = {semanticTokens = {multilineTokenSupport = true}}}
  return vim.tbl_deep_extend("force", cmp.get_lsp_capabilities(), opts)
end
local function lsp_format_on_save(client, bufid)
  local case_13_, case_14_ = pcall(require, "conform")
  local and_15_ = ((case_13_ == false) and true)
  if and_15_ then
    local _ = case_14_
    and_15_ = client:supports_method("textDocument/formatting")
  end
  if and_15_ then
    local _ = case_14_
    local grp = vim.api.nvim_create_augroup("lsp_format_on_save", {})
    local cb
    do
      local partial_17_ = {buffer = bufid, timeout_ms = 1000}
      local function _18_(...)
        return vim.lsp.buf.format(partial_17_, ...)
      end
      cb = _18_
    end
    vim.api.nvim_clear_autocmds({group = grp, buffer = bufid})
    return vim.api.nvim_create_autocmd("BufWritePre", {group = grp, buffer = bufid, callback = cb})
  else
    return nil
  end
end
local function lsp_codelens_refresh(client, bufid)
  if client:supports_method("textDocument/codeLens") then
    local grp = vim.api.nvim_create_augroup("lsp_codelens_refresh", {})
    vim.api.nvim_clear_autocmds({group = grp, buffer = bufid})
    vim.lsp.codelens.refresh()
    return vim.api.nvim_create_autocmd({"BufEnter", "InsertLeave"}, {group = grp, buffer = bufid, callback = vim.lsp.codelens.refresh})
  else
    return nil
  end
end
M.lsp_on_attach = function(client, bufid)
  vim.bo[bufid]["omnifunc"] = nil
  local maps = require("core.maps")
  maps.lsp(bufid)
  lsp_format_on_save(client, bufid)
  lsp_codelens_refresh(client, bufid)
  return nil
end
M.list_includes = function(a, b)
  vim.validate("a", a, "table")
  vim.validate("b", b, "table")
  if (#a < #b) then
    return false
  else
  end
  for _, bv in ipairs(b) do
    local found = false
    for _0, av in ipairs(a) do
      if (av == bv) then
        found = true
        break
      else
      end
    end
    if not found then
      return false
    else
    end
  end
  return true
end
M.get_selection_line_range = function()
  local a = vim.fn.line("v")
  local b = vim.fn.line(".")
  if (a <= b) then
    return a, b
  else
    return b, a
  end
end
M.get_last_selection_text = function()
  vim.cmd("normal! gv\"xy")
  return vim.fn.trim(vim.fn.getreg("x"))
end
M.get_current_selection_text = function()
  vim.cmd("exe  \"normal \\<Esc>\"")
  vim.cmd("normal! gv\"xy")
  return vim.fn.trim(vim.fn.getreg("x"))
end
M.open_hover_window = function(text_or_lines, title, callback)
  local lines
  do
    local case_25_ = type(text_or_lines)
    if (case_25_ == "string") then
      lines = vim.fn.split(text_or_lines, "\n", true)
    else
      local _ = case_25_
      lines = text_or_lines
    end
  end
  local max_cols = 0
  for _, l in ipairs(lines) do
    max_cols = math.max(max_cols, vim.api.nvim_strwidth(l))
  end
  local bufid = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufid, 0, -1, false, lines)
  local winid = vim.api.nvim_open_win(bufid, true, {relative = "cursor", row = 1, col = 0, width = max_cols, height = math.min(16, #lines), style = "minimal", title = title})
  M.disable_diagnostic(bufid)
  vim.bo[bufid]["readonly"] = true
  vim.bo[bufid]["modifiable"] = false
  vim.wo[winid]["wrap"] = false
  if callback then
    return callback(bufid, winid)
  else
    return nil
  end
end
M.create_keymaps_for_goto_entry = function(pattern, prev_key, next_key, tag, bufid)
  vim.keymap.set({"n", "v", "o"}, prev_key, string.format("<Cmd>call search('%s', 'bw')<CR>", pattern), {buffer = bufid, silent = true, desc = string.format("[goto_entry] Goto prev %s entry", tag)})
  return vim.keymap.set({"n", "v", "o"}, next_key, string.format("<Cmd>call search('%s', 'w')<CR>", pattern), {buffer = bufid, silent = true, desc = string.format("[goto_entry] Goto next %s entry", tag)})
end
return M
