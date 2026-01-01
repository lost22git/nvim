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
local GUI_CURSOR_CACHE = nil
local function _8_()
  GUI_CURSOR_CACHE = vim.opt.guicursor:get()
  vim.opt.guicursor = {}
  vim.fn.chansend(vim.v.stderr, "\27[6 q \27[?12l")
  return nil
end
vim.api.nvim_create_autocmd({"VimLeave", "VimSuspend"}, {desc = "[Cursor Style] Restore terminal cursor style", pattern = "*", callback = _8_})
local function _9_()
  if GUI_CURSOR_CACHE then
    vim.opt.guicursor = GUI_CURSOR_CACHE
    return nil
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("VimResume", {desc = "[Cursor Style] Restore nvim cursor style", pattern = "*", callback = _9_})
local _12_
do
  local t_11_ = vim.env
  if (nil ~= t_11_) then
    t_11_ = t_11_.TMUX
  else
  end
  _12_ = t_11_
end
if _12_ then
  local function _14_(_241)
    local cmd = ("tmux source-file " .. vim.api.nvim_buf_get_name(_241.buf))
    vim.fn.system(cmd)
    return nil
  end
  vim.api.nvim_create_autocmd("BufWritePost", {desc = "[Tmux] Reload tmux config after [.tmux.conf] saved", pattern = ".tmux.conf", callback = _14_})
else
end
local function _16_(_241)
  return create_keymaps_for_goto_entry("\\v^\\w+.*:$", "[e", "]e", "just_task", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Just] add keymaps for Goto prev/next task", pattern = "just", callback = _16_})
local function _17_(_241)
  return create_keymaps_for_goto_entry("\\v^<(HEAD|GET|POST|PUT|PATCH|DELETE|OPTION)>", "[e", "]e", "http_request", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Http] add keymaps for Goto prev/next http request", pattern = {"http", "rest", "hurl"}, callback = _17_})
local function _18_(_241)
  return create_keymaps_for_goto_entry("\\v(^\\(comment|^#_)", "[C", "]C", "comment_form", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add keymaps for Goto prev/next (comment)", pattern = {"clojure", "janet"}, callback = _18_})
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
  return vim.cmd(("tabnew | term " .. cmd))
end
local function _20_(_241)
  local function _22_(_21_)
    local args = _21_.args
    return start_clojure_nrepl_server(args)
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "Clj", _22_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add `Clj` usercommand for starting Clojure nREPL server", pattern = "clojure", callback = _20_})
local function _23_(_241)
  local function _24_()
    return vim.cmd(("tabnew | term " .. "janet-netrepl"))
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "Janet", _24_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Janet] add `Janet` usercommand for starting janet-netrepl server", pattern = "janet", callback = _23_})
local function _25_(_241)
  local function _26_()
    return vim.cmd(("tabnew | term " .. "sbcl --eval \"(ql:quickload :swank)\" --eval \"(swank:create-server :dont-close t)\""))
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "Lisp", _26_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Lisp] add `Lisp` usercommand for starting swank server", pattern = "lisp", callback = _25_})
local function _27_(_241)
  local function _28_()
    return vim.cmd(("tabnew | term " .. "basilisp nrepl-server"))
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "Basilisp", _28_, {nargs = "*"})
end
return vim.api.nvim_create_autocmd("FileType", {desc = "[Basilisp] add `Basilisp` usercommand for starting Basilisp nrepl server", pattern = "clojure", callback = _27_})
