-- [nfnl] fnl/core/aucmds.fnl
local _local_1_ = require("core.utils")
local create_keymaps_for_goto_entries = _local_1_["create_keymaps_for_goto_entries"]
vim.cmd("\n  au BufNewFile,BufReadPost *.bb set filetype=clojure\n  au BufNewFile,BufReadPost *.c3 set filetype=c3\n  au BufNewFile,BufReadPost *.cljd set filetype=clojure\n  au BufNewFile,BufReadPost *.cy set filetype=cyber\n  au BufNewFile,BufReadPost *.flix set filetype=flix\n  au BufNewFile,BufReadPost *.http set filetype=http\n  au BufNewFile,BufReadPost *.kk set filetype=koka\n  au BufNewFile,BufReadPost *.lfe set filetype=lfe\n  au BufNewFile,BufReadPost *.lobster set filetype=lobster\n  au BufNewFile,BufReadPost *.postcss set filetype=postcss\n  au BufNewFile,BufReadPost *.v set filetype=vlang\n")
vim.cmd("\n  au FileType c3 setlocal commentstring=//\\ %s\n  au FileType cyber setlocal commentstring=--\\ %s\n  au FileType flix setlocal commentstring=//\\ %s\n  au FileType http setlocal commentstring=#\\ %s\n  au FileType inko setlocal commentstring=#\\ %s\n  au FileType janet setlocal commentstring=#\\ %s\n  au FileType json setlocal commentstring=//\\ %s\n  au FileType just setlocal commentstring=#\\ %s\n  au FileType koka setlocal commentstring=//\\ %s\n  au FileType lfe setlocal commentstring=;\\ %s\n  au FileType lobster setlocal commentstring=//\\ %s\n")
local _3_
do
  local t_2_ = vim.env
  if (nil ~= t_2_) then
    t_2_ = t_2_.TMUX
  else
  end
  _3_ = t_2_
end
if _3_ then
  vim.cmd("\n    augroup tmux_status_bar_toggle\n      autocmd VimEnter,VimResume  * call system('tmux set status off')\n      autocmd VimLeave,VimSuspend * call system('tmux set status on')\n    augroup END\n  ")
else
end
local GUI_CURSOR_CACHE = nil
local function _6_()
  GUI_CURSOR_CACHE = vim.opt.guicursor:get()
  vim.opt.guicursor = {}
  return vim.fn.chansend(vim.v.stderr, "\27[6 q \27[?12l")
end
vim.api.nvim_create_autocmd({"VimLeave", "VimSuspend"}, {desc = "restore terminal cursor style", pattern = "*", callback = _6_})
local function _7_()
  if GUI_CURSOR_CACHE then
    vim.opt.guicursor = GUI_CURSOR_CACHE
    return nil
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("VimResume", {desc = "restore nvim cursor style", pattern = "*", callback = _7_})
local function _9_()
  if (vim.bo.modifiable and not vim.tbl_contains({"qf", "FTerm"}, vim.bo.filetype)) then
    vim.bo.fileformat = "unix"
    return nil
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("FileType", {desc = "set fileformat to unix", pattern = "*", callback = _9_})
local function _11_()
  return vim.hl.on_yank({higroup = "Visual", timeout = 200})
end
vim.api.nvim_create_autocmd("TextYankPost", {desc = "highlight yanked text", pattern = "*", callback = _11_})
local function _12_(_241)
  return create_keymaps_for_goto_entries("[-\\/;#] === .\\+ ===$", "[r", "]r", "code_region", _241.buf)
end
vim.api.nvim_create_autocmd("BufWinEnter", {desc = "add keymaps for Goto prev/next region", callback = _12_})
local function _13_(_241)
  return create_keymaps_for_goto_entries("\\v(^\\(comment|^#_)", "[C", "]C", "comment_form", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add keymaps for Goto prev/next (comment)", pattern = {"clojure", "janet"}, callback = _13_})
local function _14_(_241)
  return create_keymaps_for_goto_entries("\\v^\\w+.*:$", "[e", "]e", "just_task", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Just] add keymaps for Goto prev/next task", pattern = "just", callback = _14_})
local function nvim_help()
  local _local_15_ = require("core.utils")
  local on_v_modes = _local_15_["on_v_modes"]
  local get_current_selection_text = _local_15_["get_current_selection_text"]
  local q
  if on_v_modes() then
    q = get_current_selection_text()
  else
    q = vim.fn.expand("<cword>")
  end
  return vim.cmd(("help " .. q))
end
local function _18_(_17_)
  local bufid = _17_["buf"]
  local function cb()
    if (1 == vim.fn.bufexists(bufid)) then
      return vim.keymap.set({"n", "v"}, "<Leader>k", nvim_help, {buffer = bufid, desc = "[base] Nvim help"})
    else
      return nil
    end
  end
  return vim.defer_fn(cb, 1000)
end
vim.api.nvim_create_autocmd("FileType", {desc = "add keymaps for nvim help", pattern = "lua", callback = _18_})
local add_keymaps_for_docr = nil
local function docr(subcmd)
  local function open_doc_window(obj, title)
    print("")
    local text = vim.fn.trim(assert(obj.stdout))
    local _local_20_ = require("core.utils")
    local open_hover_window = _local_20_["open_hover_window"]
    local function _21_(bufid, _winid)
      vim.bo[bufid]["filetype"] = "markdown"
      return add_keymaps_for_docr(bufid)
    end
    return open_hover_window(text, title, _21_)
  end
  local _local_22_ = require("core.utils")
  local on_v_modes = _local_22_["on_v_modes"]
  local get_current_selection_text = _local_22_["get_current_selection_text"]
  local q
  if on_v_modes() then
    q = get_current_selection_text()
  else
    q = vim.fn.expand("<cword>")
  end
  local cmd = {"docr", subcmd, ("'" .. vim.fn.escape(q, "'") .. "'")}
  local cmd_str = table.concat(cmd, " ")
  print(cmd_str, " ...")
  local function _24_(res)
    if ((0 ~= res.code) or not res.stdout or ("" == res.stdout)) then
      return vim.print(cmd_str, res)
    else
      return vim.schedule_wrap(open_doc_window)(res, cmd_str)
    end
  end
  return vim.system(cmd, {text = true}, _24_)
end
local function _26_(bufid)
  local function _27_(...)
    return docr("info", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>k", _27_, {buffer = bufid, desc = "[base] docr info"})
  local function _28_(...)
    return docr("search", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>K", _28_, {buffer = bufid, desc = "[base] docr search"})
  local function _29_(...)
    return docr("tree", ...)
  end
  return vim.keymap.set({"n", "v"}, "<Leader>kk", _29_, {buffer = bufid, desc = "[base] docr tree"})
end
add_keymaps_for_docr = _26_
local function _30_(_241)
  return add_keymaps_for_docr(_241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Crystal] add keymaps for docr", pattern = "crystal", callback = _30_})
local function lfe_doc(m_or_h)
  local function open_doc_window(obj, title)
    print("")
    local text = vim.fn.trim(assert(obj.stdout))
    local _local_31_ = require("core.utils")
    local open_hover_window = _local_31_["open_hover_window"]
    local function _32_(bufid, _winid)
      vim.bo[bufid]["filetype"] = "markdown"
      return nil
    end
    return open_hover_window(text, title, _32_)
  end
  local function make_cmd(q)
    local qq
    if (m_or_h == "m") then
      qq = ("(m '" .. q .. ")")
    elseif (m_or_h == "h") then
      local _local_33_ = vim.split(q, ":")
      local m = _local_33_[1]
      local fa = _local_33_[2]
      local function _34_()
        if fa then
          return vim.split(fa, "/")
        else
          return {}
        end
      end
      local _local_35_ = _34_()
      local f = _local_35_[1]
      local a = _local_35_[2]
      local _36_
      if m then
        _36_ = (" '" .. m)
      else
        _36_ = ""
      end
      local _38_
      if f then
        _38_ = (" '" .. f)
      else
        _38_ = ""
      end
      local _40_
      if a then
        _40_ = (" " .. a)
      else
        _40_ = ""
      end
      qq = ("(h" .. _36_ .. _38_ .. _40_ .. ")")
    else
      qq = nil
    end
    return {"lfe", "-e", qq}
  end
  local _local_43_ = require("core.utils")
  local on_v_modes = _local_43_["on_v_modes"]
  local get_current_selection_text = _local_43_["get_current_selection_text"]
  local q
  if on_v_modes() then
    q = get_current_selection_text()
  else
    q = vim.fn.expand("<cword>")
  end
  local cmd = make_cmd(q)
  local cmd_str = table.concat(cmd, " ")
  print(cmd_str, " ...")
  local function _45_(res)
    if ((0 ~= res.code) or not res.stdout or ("" == res.stdout)) then
      return vim.print(cmd_str, res)
    else
      return vim.schedule_wrap(open_doc_window)(res, cmd_str)
    end
  end
  return vim.system(cmd, {text = true, stdin = string.rep("y\n", 10)}, _45_)
end
local function _48_(_47_)
  local bufid = _47_["buf"]
  local function _49_(...)
    return lfe_doc("h", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>k", _49_, {buffer = bufid, desc = "[base] lfe (h mod fun arity)"})
  local function _50_(...)
    return lfe_doc("m", ...)
  end
  return vim.keymap.set({"n", "v"}, "<Leader>K", _50_, {buffer = bufid, desc = "[base] lfe (m mod)"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[LFE] add keymaps for (m mode) or (h mod fun arity)", pattern = "lfe", callback = _48_})
local function _51_()
  local function _53_(_52_)
    local args = _52_["args"]
    local clj_opts
    if string.match(args, "%-M:") then
      clj_opts = args
    else
      clj_opts = (args .. " " .. "-M")
    end
    local deps = "'{:deps {nrepl/nrepl {:mvn/version \"1.3.0\"} refactor-nrepl/refactor-nrepl {:mvn/version \"3.10.0\"} cider/cider-nrepl {:mvn/version \"0.52.0\"} }}'"
    local cider_opts = "\"(require 'nrepl.cmdline) (nrepl.cmdline/-main \\\"--interactive\\\" \\\"--middleware\\\" \\\"[refactor-nrepl.middleware/wrap-refactor cider.nrepl/cider-middleware]\\\")\""
    local command = string.format("clj -Sdeps %s %s -e %s", deps, clj_opts, cider_opts)
    return vim.cmd(("tabnew | term " .. command))
  end
  return vim.api.nvim_buf_create_user_command(0, "Clj", _53_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add `Clj` usercommand for starting Clojure nREPL server", pattern = "clojure", callback = _51_})
local function _55_(_241)
  local function _56_()
    return vim.cmd(("tabnew | term " .. "janet-netrepl"))
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "JanetNetrepl", _56_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Janet] add `JanetNetrepl` usercommand for starting janet-netrepl server", pattern = "janet", callback = _55_})
local run_visual = {state = {bufid = nil, winid = nil}}
run_visual.buffer_append = function(lines)
  local bufid = run_visual.state["bufid"]
  local winid = run_visual.state["winid"]
  local line_start = vim.api.nvim_buf_line_count(bufid)
  if (1 == line_start) then
    line_start = 0
  else
  end
  vim.api.nvim_buf_set_lines(bufid, line_start, -1, false, lines)
  return vim.api.nvim_win_set_cursor(winid, {vim.api.nvim_buf_line_count(bufid), 0})
end
run_visual.read_selection_and_write_to_tmp_file = function()
  local _local_58_ = require("core.utils")
  local get_last_selection_text = _local_58_["get_last_selection_text"]
  local selection_text = get_last_selection_text()
  local tmp_file = (vim.fs.dirname(os.tmpname()) .. "/nvim_run_visual_tmp")
  vim.fn.writefile(vim.split(selection_text, "\n"), tmp_file)
  if (vim.fn.has("unix") == 1) then
    os.execute(("chmod 777 " .. tmp_file))
  else
  end
  return tmp_file
end
run_visual.ensure_buf_and_win = function()
  local or_60_ = not run_visual.state.bufid
  if not or_60_ then
    local _61_ = vim.fn.bufexists
    or_60_ = ((0 == _61_) and (_61_ == run_visual.state.bufid))
  end
  if or_60_ then
    run_visual.state.bufid = vim.api.nvim_create_buf(false, true)
    vim.bo[run_visual.state.bufid]["filetype"] = "RunVisual"
  else
  end
  if not (run_visual.state.winid and vim.api.nvim_win_is_valid(run_visual.state.winid)) then
    run_visual.state.winid = vim.api.nvim_open_win(run_visual.state.bufid, false, {split = "below", style = "minimal"})
    return nil
  else
    return nil
  end
end
local function _64_(_241)
  local function _66_(_65_)
    local fargs = _65_["fargs"]
    local tmp_file = run_visual.read_selection_and_write_to_tmp_file()
    local cmd = {unpack(fargs), tmp_file}
    run_visual.ensure_buf_and_win()
    do
      local time_str = os.date("!%m-%d %H:%M:%S", os.time())
      local title_lines = {("# " .. string.rep("-", 80)), ("# " .. time_str .. " - " .. table.concat(cmd, " "))}
      run_visual.buffer_append(title_lines)
    end
    local function print_cmd_result(obj)
      local text
      if (obj.stdout and (obj.stdout ~= "")) then
        text = obj.stdout
      else
        text = vim.inspect(obj)
      end
      return run_visual.buffer_append(vim.fn.split(vim.fn.trim(text), "\n", true))
    end
    local function _68_(_2410)
      return vim.schedule_wrap(print_cmd_result)(_2410)
    end
    return vim.system(cmd, {text = true}, _68_)
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "RunVisual", _66_, {nargs = "+", range = true})
end
vim.api.nvim_create_autocmd("BufWinEnter", {desc = "create `RunVisual` usercommand", callback = _64_})
local function _69_(_241)
  return create_keymaps_for_goto_entries("\\v^# \\-+$", "[e", "]e", "run_visual_log", _241.buf)
end
return vim.api.nvim_create_autocmd("FileType", {desc = "[RunVisual] add keymaps for goto prev/next log", pattern = "RunVisual", callback = _69_})
