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
  local and_4_ = path
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
    path = (path .. ".cmd")
  else
  end
  return path
end
M.lsp_server_path = function(name)
  return (find_lsp_server_from_mason(name) or find_lsp_server_from_env_path(name))
end
M.lsp_with_server = function(name, f)
  local case_9_ = M.lsp_server_path(name)
  if (nil ~= case_9_) then
    local path = case_9_
    return f(path)
  else
    return nil
  end
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
M.create_keymaps_for_goto_entry = function(pattern, prev_key, next_key, tag, bufid)
  vim.keymap.set({"n", "v", "o"}, prev_key, string.format("<Cmd>call search('%s', 'bw')<CR>", pattern), {buffer = bufid, silent = true, desc = string.format("[goto_entry] Goto prev %s entry", tag)})
  return vim.keymap.set({"n", "v", "o"}, next_key, string.format("<Cmd>call search('%s', 'w')<CR>", pattern), {buffer = bufid, silent = true, desc = string.format("[goto_entry] Goto next %s entry", tag)})
end
return M
