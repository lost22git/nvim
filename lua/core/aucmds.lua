-- [nfnl] fnl/core/aucmds.fnl
local _local_1_ = require("core.utils")
local create_keymaps_for_goto_entry = _local_1_["create_keymaps_for_goto_entry"]
local on_v_modes = _local_1_["on_v_modes"]
local get_current_selection_text = _local_1_["get_current_selection_text"]
local get_last_selection_text = _local_1_["get_last_selection_text"]
local open_hover_window = _local_1_["open_hover_window"]
vim.cmd("\n  au BufNewFile,BufReadPost *.art set filetype=arturo\n  au BufNewFile,BufReadPost *.bb set filetype=clojure\n  au BufNewFile,BufReadPost *.c3 set filetype=c3\n  au BufNewFile,BufReadPost *.cljd set filetype=clojure\n  au BufNewFile,BufReadPost *.cy set filetype=cyber\n  au BufNewFile,BufReadPost *.flix set filetype=flix\n  au BufNewFile,BufReadPost *.http set filetype=http\n  au BufNewFile,BufReadPost *.kk set filetype=koka\n  au BufNewFile,BufReadPost *.lfe set filetype=lfe\n  au BufNewFile,BufReadPost *.lobster set filetype=lobster\n  au BufNewFile,BufReadPost *.n set filetype=nature\n  au BufNewFile,BufReadPost *.postcss set filetype=postcss\n  au BufNewFile,BufReadPost *.v set filetype=vlang\n")
vim.cmd("\n  au FileType arturo setlocal commentstring=;\\ %s\n  au FileType c3 setlocal commentstring=//\\ %s\n  au FileType crystal setlocal commentstring=#\\ %s\n  au FileType cyber setlocal commentstring=--\\ %s\n  au FileType fennel setlocal commentstring=;;\\ %s\n  au FileType flix setlocal commentstring=//\\ %s\n  au FileType http setlocal commentstring=#\\ %s\n  au FileType inko setlocal commentstring=#\\ %s\n  au FileType janet setlocal commentstring=#\\ %s\n  au FileType json setlocal commentstring=//\\ %s\n  au FileType just setlocal commentstring=#\\ %s\n  au FileType koka setlocal commentstring=//\\ %s\n  au FileType lfe setlocal commentstring=;\\ %s\n  au FileType lobster setlocal commentstring=//\\ %s\n  au FileType nature setlocal commentstring=//\\ %s\n")
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
  return create_keymaps_for_goto_entry("[-\\/;#] === .\\+ ===$", "[r", "]r", "code_region", _241.buf)
end
vim.api.nvim_create_autocmd("BufWinEnter", {desc = "add keymaps for Goto prev/next region", callback = _12_})
local function _13_(_241)
  return create_keymaps_for_goto_entry("\\v(^\\(comment|^#_)", "[C", "]C", "comment_form", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add keymaps for Goto prev/next (comment)", pattern = {"clojure", "janet"}, callback = _13_})
local function _14_(_241)
  return create_keymaps_for_goto_entry("\\v^\\w+.*:$", "[e", "]e", "just_task", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Just] add keymaps for Goto prev/next task", pattern = "just", callback = _14_})
local function _15_(_241)
  return create_keymaps_for_goto_entry("\\v^<(HEAD|GET|POST|PUT|PATCH|DELETE|OPTION)>", "[e", "]e", "http_request", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Http] add keymaps for Goto prev/next http request", pattern = {"http", "rest", "hurl"}, callback = _15_})
local function nvim_help()
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
    local function _20_(bufid, _winid)
      vim.bo[bufid]["filetype"] = "markdown"
      return add_keymaps_for_docr(bufid)
    end
    return open_hover_window(text, title, _20_)
  end
  local q
  if on_v_modes() then
    q = get_current_selection_text()
  else
    q = vim.fn.expand("<cword>")
  end
  local cmd = {"docr", subcmd, ("'" .. vim.fn.escape(q, "'") .. "'")}
  local cmd_str = table.concat(cmd, " ")
  print(cmd_str, " ...")
  local function _22_(res)
    if ((0 ~= res.code) or not res.stdout or ("" == res.stdout)) then
      return vim.print(cmd_str, res)
    else
      return vim.schedule_wrap(open_doc_window)(res, cmd_str)
    end
  end
  return vim.system(cmd, {text = true}, _22_)
end
local function _24_(bufid)
  local function _25_(...)
    return docr("info", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>k", _25_, {buffer = bufid, desc = "[base] docr info"})
  local function _26_(...)
    return docr("search", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>K", _26_, {buffer = bufid, desc = "[base] docr search"})
  local function _27_(...)
    return docr("tree", ...)
  end
  return vim.keymap.set({"n", "v"}, "<Leader>kk", _27_, {buffer = bufid, desc = "[base] docr tree"})
end
add_keymaps_for_docr = _24_
local function _28_(_241)
  return add_keymaps_for_docr(_241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Crystal] add keymaps for docr", pattern = "crystal", callback = _28_})
local function lfe_doc(m_or_h)
  local function open_doc_window(obj, title)
    print("")
    local text = vim.fn.trim(assert(obj.stdout))
    local function _29_(bufid, _winid)
      vim.bo[bufid]["filetype"] = "markdown"
      return nil
    end
    return open_hover_window(text, title, _29_)
  end
  local function make_cmd(q)
    local qq
    if (m_or_h == "m") then
      qq = ("(m '" .. q .. ")")
    elseif (m_or_h == "h") then
      local _local_30_ = vim.split(q, ":")
      local m = _local_30_[1]
      local fa = _local_30_[2]
      local function _31_()
        if fa then
          return vim.split(fa, "/")
        else
          return {}
        end
      end
      local _local_32_ = _31_()
      local f = _local_32_[1]
      local a = _local_32_[2]
      local _33_
      if m then
        _33_ = (" '" .. m)
      else
        _33_ = ""
      end
      local _35_
      if f then
        _35_ = (" '" .. f)
      else
        _35_ = ""
      end
      local _37_
      if a then
        _37_ = (" " .. a)
      else
        _37_ = ""
      end
      qq = ("(h" .. _33_ .. _35_ .. _37_ .. ")")
    else
      qq = nil
    end
    return {"lfe", "-e", qq}
  end
  local q
  if on_v_modes() then
    q = get_current_selection_text()
  else
    q = vim.fn.expand("<cword>")
  end
  local cmd = make_cmd(q)
  local cmd_str = table.concat(cmd, " ")
  print(cmd_str, " ...")
  local function _41_(res)
    if ((0 ~= res.code) or not res.stdout or ("" == res.stdout)) then
      return vim.print(cmd_str, res)
    else
      return vim.schedule_wrap(open_doc_window)(res, cmd_str)
    end
  end
  return vim.system(cmd, {text = true, stdin = string.rep("y\n", 10)}, _41_)
end
local function _44_(_43_)
  local bufid = _43_["buf"]
  local function _45_(...)
    return lfe_doc("h", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>k", _45_, {buffer = bufid, desc = "[base] lfe (h mod fun arity)"})
  local function _46_(...)
    return lfe_doc("m", ...)
  end
  return vim.keymap.set({"n", "v"}, "<Leader>K", _46_, {buffer = bufid, desc = "[base] lfe (m mod)"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[LFE] add keymaps for (m mode) or (h mod fun arity)", pattern = "lfe", callback = _44_})
local function _47_()
  local function _49_(_48_)
    local args = _48_["args"]
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
  return vim.api.nvim_buf_create_user_command(0, "Clj", _49_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add `Clj` usercommand for starting Clojure nREPL server", pattern = "clojure", callback = _47_})
local function _51_(_241)
  local function _52_()
    return vim.cmd(("tabnew | term " .. "janet-netrepl"))
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "JanetNetrepl", _52_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Janet] add `JanetNetrepl` usercommand for starting janet-netrepl server", pattern = "janet", callback = _51_})
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
  local or_55_ = not run_visual.state.bufid
  if not or_55_ then
    local _56_ = vim.fn.bufexists
    or_55_ = ((0 == _56_) and (_56_ == run_visual.state.bufid))
  end
  if or_55_ then
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
local function _59_(_241)
  local function _61_(_60_)
    local fargs = _60_["fargs"]
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
      do
        local _62_ = obj.code
        if (_62_ == 0) then
          text = obj.stdout
        elseif (nil ~= _62_) then
          local code = _62_
          text = ("Code: " .. code .. "\n" .. obj.stderr)
        else
          text = nil
        end
      end
      local function _66_()
        local _64_, _65_ = string.gsub(text, "\27%[.-m", "")
        if ((nil ~= _64_) and true) then
          local a = _64_
          local _ = _65_
          return a
        else
          return nil
        end
      end
      return run_visual.buffer_append(vim.fn.split(vim.fn.trim(_66_()), "\n", true))
    end
    local function _68_(_2410)
      return vim.schedule_wrap(print_cmd_result)(_2410)
    end
    return vim.system(cmd, {text = true}, _68_)
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "RunVisual", _61_, {nargs = "+", range = true})
end
vim.api.nvim_create_autocmd("BufWinEnter", {desc = "create `RunVisual` usercommand", callback = _59_})
local function _69_(_241)
  return create_keymaps_for_goto_entry("\\v^# \\-+$", "[e", "]e", "run_visual_log", _241.buf)
end
return vim.api.nvim_create_autocmd("FileType", {desc = "[RunVisual] add keymaps for goto prev/next log", pattern = "RunVisual", callback = _69_})
