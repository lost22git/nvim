-- [nfnl] fnl/core/utils.fnl
local M = {}
M.on_gui = function()
  return (vim.g.neovide or vim.g.fvim_loaded or vim.g.vscode)
end
M.on_v_modes = function()
  local v_block_mode = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)
  local v_modes = {"v", "V", v_block_mode}
  return vim.tbl_contains(v_modes, vim.fn.mode())
end
M.get_flutter_path = function()
  local path = vim.fn.exepath("flutter")
  if (vim.fn.has("win32") == 1) then
    return (path .. ".bat")
  else
    return path
  end
end
M.disable_diagnostic = function(bufid)
  if vim.diagnostic.is_enabled({bufnr = bufid}) then
    return pcall(vim.diagnostic.enable, false, {bufnr = bufid})
  else
    return nil
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
    return (path .. ".cmd")
  else
    return path
  end
end
local function find_lsp_server_from_env_path(name)
  local path = vim.fn.exepath(name)
  local and_4_ = path and ("" ~= path)
  if and_4_ then
    and_4_ = (vim.fn.has("win32") == 1)
  end
  if and_4_ then
    local _6_
    do
      local t_5_ = vim.fn.split(vim.fs.basename(path), "\\.")
      if (nil ~= t_5_) then
        t_5_ = t_5_[2]
      else
      end
      _6_ = t_5_
    end
    and_4_ = not _6_
  end
  if and_4_ then
    return (path .. ".cmd")
  else
    return path
  end
end
M.lsp_server_path = function(name)
  local path = (find_lsp_server_from_mason(name) or find_lsp_server_from_env_path(name))
  if (1 == vim.fn.executable(path)) then
    return path
  else
    return nil
  end
end
M.lsp_with_server = function(name, f)
  local path = M.lsp_server_path(name)
  if path then
    return f(path)
  else
    return nil
  end
end
M.lsp_capabilities = function()
  local cmp = require("blink.cmp")
  local opts = {textDocument = {semanticTokens = {multilineTokenSupport = true}}, workspace = {fileOperations = {didRename = true, willRename = true}}}
  return vim.tbl_deep_extend("force", cmp.get_lsp_capabilities(), opts)
end
local function lsp_format_on_save(client, bufid)
  local has_conform, _ = pcall(require, "conform")
  if (not has_conform and client:supports_method("textDocument/formatting")) then
    local grp = vim.api.nvim_create_augroup("lsp_format_on_save", {})
    local cb
    do
      local _11_ = {buffer = bufid, timeout_ms = 1000}
      local function _12_(...)
        return vim.lsp.buf.format(_11_, ...)
      end
      cb = _12_
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
M.system_open = function(path)
  vim.notify(("system_open path=" .. path), vim.log.levels.INFO)
  local cmd
  if (vim.fn.has("win32") == 1) then
    cmd = ("explorer.exe '" .. path .. "'")
  else
    if (vim.fn.has("macunix") == 1) then
      cmd = ("open -g '" .. path .. "' &")
    else
      cmd = ("xdg-open '" .. path .. "' &")
    end
  end
  return vim.fn.jobstart(cmd, {detach = true})
end
M.tbl_includes = function(a, b)
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
M.get_buffer_count = function()
  local result = 0
  local bufs = vim.api.nvim_list_bufs()
  for _, bufid in ipairs(bufs) do
    if vim.bo[bufid].buflisted then
      result = (result + 1)
    else
    end
  end
  return result
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
  if ("string" == type(text_or_lines)) then
    lines = vim.fn.split(text_or_lines, "\n", true)
  else
    lines = text_or_lines
  end
  local max_cols = 0
  for _, l in ipairs(lines) do
    max_cols = math.max(max_cols, vim.api.nvim_strwidth(l))
  end
  local bufid = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufid, 0, #lines, false, lines)
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
M.get_justfile_tasks = function(justfile)
  local cmd = {"just", "-f", justfile, "--list"}
  local cmd_result = vim.system(cmd, {text = true}):wait()
  local tbl_21_ = {}
  local i_22_ = 0
  for _, line in ipairs(vim.fn.split(cmd_result.stdout, "\n", false)) do
    local val_23_
    if vim.startswith(line, "   ") then
      local _local_24_ = vim.fn.split(line, "#", false)
      local name = _local_24_[1]
      local desc = _local_24_[2]
      local _25_
      if desc then
        _25_ = vim.trim(desc)
      else
        _25_ = nil
      end
      val_23_ = {name = vim.trim(name), desc = _25_, justfile = justfile}
    else
      val_23_ = nil
    end
    if (nil ~= val_23_) then
      i_22_ = (i_22_ + 1)
      tbl_21_[i_22_] = val_23_
    else
    end
  end
  return tbl_21_
end
M.run_justfile_task = function(task)
  local _local_29_ = vim.fn.split(task.name, " ", false)
  local task_name = _local_29_[1]
  local task_args = _local_29_[2]
  local cmd = ("just -f " .. task.justfile .. " " .. task_name)
  if task_args then
    local function _30_(_241)
      if _241 then
        return vim.cmd(("AsyncRun " .. cmd .. " " .. _241))
      else
        return nil
      end
    end
    return vim.ui.input({prompt = ("just " .. task.name .. ": ")}, _30_)
  else
    return vim.cmd(("AsyncRun " .. cmd))
  end
end
return M
