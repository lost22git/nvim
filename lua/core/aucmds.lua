-- [nfnl] fnl/core/aucmds.fnl
local _local_1_ = require("core.utils")
local create_keymaps_for_goto_entry = _local_1_.create_keymaps_for_goto_entry
local function _2_()
  if (vim.bo.modifiable and not vim.list_contains({"qf", "FTerm"}, vim.bo.filetype)) then
    vim.bo.fileformat = "unix"
    return nil
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("FileType", {desc = "Set fileformat to unix", pattern = "*", callback = _2_})
local function _4_()
  return vim.hl.on_yank({higroup = "Visual", timeout = 200})
end
vim.api.nvim_create_autocmd("TextYankPost", {desc = "Highlight yanked text", pattern = "*", callback = _4_})
local function _5_()
  return vim.cmd("silent! normal! g`\"zv")
end
vim.api.nvim_create_autocmd("BufReadPost", {desc = "Restore cursor position", callback = _5_})
local function _6_()
  vim.opt_local.buflisted = false
  return nil
end
vim.api.nvim_create_autocmd("FileType", {desc = "Do not list quickfix buffers", pattern = "qf", callback = _6_})
local function _7_(_241)
  return create_keymaps_for_goto_entry("[-\\/;#\\*] === .\\+ ===", "[r", "]r", "code_region", _241.buf)
end
vim.api.nvim_create_autocmd("BufWinEnter", {desc = "Add keymaps for Goto prev/next region", callback = _7_})
local _9_
do
  local t_8_ = vim.env
  if (nil ~= t_8_) then
    t_8_ = t_8_.TMUX
  else
  end
  _9_ = t_8_
end
if _9_ then
  local function _11_(_241)
    local cmd = ("tmux source-file " .. vim.api.nvim_buf_get_name(_241.buf))
    vim.fn.system(cmd)
    return nil
  end
  vim.api.nvim_create_autocmd("BufWritePost", {desc = "[Tmux] Reload tmux config after [.tmux.conf] saved", pattern = ".tmux.conf", callback = _11_})
else
end
local function _13_(_241)
  return create_keymaps_for_goto_entry("\\v^\\w+.*:$", "[e", "]e", "just_task", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Just] add keymaps for Goto prev/next task", pattern = "just", callback = _13_})
local function _14_(_241)
  return create_keymaps_for_goto_entry("\\v^<(HEAD|GET|POST|PUT|PATCH|DELETE|OPTION)>", "[e", "]e", "http_request", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Http] add keymaps for Goto prev/next http request", pattern = {"http", "rest", "hurl"}, callback = _14_})
local function _15_(_241)
  return create_keymaps_for_goto_entry("\\v(^\\(comment|^#_)", "[C", "]C", "comment_form", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add keymaps for Goto prev/next (comment)", pattern = {"clojure", "janet"}, callback = _15_})
local function start_clojure_nrepl_server(args)
  local clj_opts
  if string.match(args, "%-M:") then
    clj_opts = args
  else
    clj_opts = (args .. " -M")
  end
  local deps = "'{:deps {nrepl/nrepl {:mvn/version \"1.3.0\"} refactor-nrepl/refactor-nrepl {:mvn/version \"3.10.0\"} cider/cider-nrepl {:mvn/version \"0.52.0\"} }}'"
  local cider_opts = "\"(require 'nrepl.cmdline) (nrepl.cmdline/-main \\\"--interactive\\\" \\\"--middleware\\\" \\\"[refactor-nrepl.middleware/wrap-refactor cider.nrepl/cider-middleware]\\\")\""
  local cmd = string.format("clj -Sdeps %s %s -e %s", deps, clj_opts, cider_opts)
  return vim.cmd(("0tabnew | term " .. cmd))
end
local function _17_(_241)
  local function _19_(_18_)
    local args = _18_.args
    return start_clojure_nrepl_server(args)
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "Clj", _19_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add `Clj` user command for starting Clojure nREPL server", pattern = "clojure", callback = _17_})
local function _20_(_241)
  local function _21_()
    return vim.cmd(("0tabnew | term " .. "janet-netrepl"))
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "Janet", _21_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Janet] add `Janet` user command for starting janet-netrepl server", pattern = "janet", callback = _20_})
local function _22_(_241)
  local function _23_()
    return vim.cmd(("0tabnew | term " .. "sbcl --eval \"(ql:quickload :swank)\" --eval \"(swank:create-server :dont-close t)\""))
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "SBCL", _23_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[SBCL] add `SBCL` user command for starting swank server", pattern = "lisp", callback = _22_})
local function _24_(_241)
  local function _25_()
    return vim.cmd(("0tabnew | term " .. "basilisp nrepl-server"))
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "Basilisp", _25_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Basilisp] add `Basilisp` user command for starting Basilisp nrepl server", pattern = "clojure", callback = _24_})
local function _26_()
  local function _28_(_27_)
    local args = _27_.args
    return vim.cmd(("tabnew | exe 'r !" .. args .. "' | Man!"))
  end
  return vim.api.nvim_create_user_command("Help", _28_, {nargs = "*"})
end
return vim.api.nvim_create_autocmd("UIEnter", {desc = "add `Help` user command", once = true, callback = _26_})
