-- [nfnl] fnl/core/aucmds.fnl
local _local_1_ = require("core.utils")
local create_keymaps_for_goto_entry = _local_1_["create_keymaps_for_goto_entry"]
local on_v_modes = _local_1_["on_v_modes"]
local get_current_selection_text = _local_1_["get_current_selection_text"]
local get_last_selection_text = _local_1_["get_last_selection_text"]
local open_hover_window = _local_1_["open_hover_window"]
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
local function _16_()
  local function _18_(_17_)
    local args = _17_["args"]
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
  return vim.api.nvim_buf_create_user_command(0, "Clj", _18_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add `Clj` usercommand for starting Clojure nREPL server", pattern = "clojure", callback = _16_})
local function _20_(_241)
  local function _21_()
    return vim.cmd(("tabnew | term " .. "janet-netrepl"))
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "JanetNetrepl", _21_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Janet] add `JanetNetrepl` usercommand for starting janet-netrepl server", pattern = "janet", callback = _20_})
local function nvim_help()
  local q
  if on_v_modes() then
    q = get_current_selection_text()
  else
    q = vim.fn.expand("<cword>")
  end
  return vim.cmd(("help " .. q))
end
local function _24_(_23_)
  local bufid = _23_["buf"]
  local function cb()
    if (1 == vim.fn.bufexists(bufid)) then
      return vim.keymap.set({"n", "v"}, "<Leader>k", nvim_help, {buffer = bufid, desc = "[base] Nvim help"})
    else
      return nil
    end
  end
  return vim.defer_fn(cb, 1000)
end
vim.api.nvim_create_autocmd("FileType", {desc = "add keymaps for nvim help", pattern = "lua", callback = _24_})
local add_keymaps_for_docr = nil
local function docr(subcmd)
  local function make_cmd(q)
    return {"docr", subcmd, ("'" .. vim.fn.escape(q, "'") .. "'")}
  end
  local function process_content(content)
    local function _28_()
      local _26_, _27_ = string.gsub(content, "\27%[.-m", "")
      if ((nil ~= _26_) and true) then
        local a = _26_
        local _ = _27_
        return a
      else
        return nil
      end
    end
    return vim.fn.trim(_28_())
  end
  local function open_doc_window(content, title)
    local text = process_content(content)
    local function _30_(bufid, _winid)
      vim.bo[bufid]["filetype"] = "markdown"
      return add_keymaps_for_docr(bufid)
    end
    return open_hover_window(text, title, _30_)
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
  local function _32_(res)
    print("")
    if ((0 ~= res.code) or not res.stdout or ("" == res.stdout)) then
      return vim.print(cmd_str, res)
    else
      return vim.schedule_wrap(open_doc_window)(res.stdout, cmd_str)
    end
  end
  return vim.system(cmd, {text = true}, _32_)
end
local function _34_(bufid)
  local function _35_(...)
    return docr("info", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>k", _35_, {buffer = bufid, desc = "[base] docr info"})
  local function _36_(...)
    return docr("search", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>K", _36_, {buffer = bufid, desc = "[base] docr search"})
  local function _37_(...)
    return docr("tree", ...)
  end
  return vim.keymap.set({"n", "v"}, "<Leader>kk", _37_, {buffer = bufid, desc = "[base] docr tree"})
end
add_keymaps_for_docr = _34_
local function _38_(_241)
  return add_keymaps_for_docr(_241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Crystal] add keymaps for docr", pattern = "crystal", callback = _38_})
local function arturo_doc(subcmd)
  local function make_cmd(q)
    return {"sh", "-c", ("echo \"info '" .. q .. "\" | arturo --no-color")}
  end
  local function process_content(content)
    local function _41_()
      local _39_, _40_ = string.gsub(string.match(content, "(%$%>.+)%s*%$%>"), "\27%[.-m", "")
      if ((nil ~= _39_) and true) then
        local a = _39_
        local _ = _40_
        return a
      else
        return nil
      end
    end
    return vim.fn.trim(_41_())
  end
  local function open_doc_window(content, title)
    local text = process_content(content)
    return open_hover_window(text, title)
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
  local function _44_(res)
    print("")
    if ((0 ~= res.code) or not res.stdout or ("" == res.stdout)) then
      return vim.print(cmd_str, res)
    else
      return vim.schedule_wrap(open_doc_window)(res.stdout, cmd_str)
    end
  end
  return vim.system(cmd, {text = true}, _44_)
end
local function add_keymaps_for_arturo_doc(bufid)
  local function _46_(...)
    return arturo_doc("info", ...)
  end
  return vim.keymap.set({"n", "v"}, "<Leader>k", _46_, {buffer = bufid, desc = "[base] arturo info"})
end
local function _47_(_241)
  return add_keymaps_for_arturo_doc(_241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Arturo] add keymaps for arturo doc", pattern = "arturo", callback = _47_})
local function lfe_doc(m_or_h)
  local function make_cmd(q)
    local qq
    if (m_or_h == "m") then
      qq = ("(m '" .. q .. ")")
    elseif (m_or_h == "h") then
      local _local_48_ = vim.split(q, ":")
      local m = _local_48_[1]
      local fa = _local_48_[2]
      local function _49_()
        if fa then
          return vim.split(fa, "/")
        else
          return {}
        end
      end
      local _local_50_ = _49_()
      local f = _local_50_[1]
      local a = _local_50_[2]
      local _51_
      if m then
        _51_ = (" '" .. m)
      else
        _51_ = ""
      end
      local _53_
      if f then
        _53_ = (" '" .. f)
      else
        _53_ = ""
      end
      local _55_
      if a then
        _55_ = (" " .. a)
      else
        _55_ = ""
      end
      qq = ("(h" .. _51_ .. _53_ .. _55_ .. ")")
    else
      qq = nil
    end
    return {"lfe", "-e", qq}
  end
  local function process_content(content)
    local function _60_()
      local _58_, _59_ = string.gsub(content, "\27%[.-m", "")
      if ((nil ~= _58_) and true) then
        local a = _58_
        local _ = _59_
        return a
      else
        return nil
      end
    end
    return vim.fn.trim(_60_())
  end
  local function open_doc_window(content, title)
    local text = process_content(content)
    local function _62_(bufid, _winid)
      vim.bo[bufid]["filetype"] = "markdown"
      return nil
    end
    return open_hover_window(text, title, _62_)
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
  local function _64_(res)
    print("")
    if ((0 ~= res.code) or not res.stdout or ("" == res.stdout)) then
      return vim.print(cmd_str, res)
    else
      return vim.schedule_wrap(open_doc_window)(res.stdout, cmd_str)
    end
  end
  return vim.system(cmd, {text = true, stdin = string.rep("y\n", 10)}, _64_)
end
local function add_keymaps_for_lfe_doc(bufid)
  local function _66_(...)
    return lfe_doc("h", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>k", _66_, {buffer = bufid, desc = "[base] lfe (h mod fun arity)"})
  local function _67_(...)
    return lfe_doc("m", ...)
  end
  return vim.keymap.set({"n", "v"}, "<Leader>K", _67_, {buffer = bufid, desc = "[base] lfe (m mod)"})
end
local function _68_(_241)
  return add_keymaps_for_lfe_doc(_241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[LFE] add keymaps for (m mode) or (h mod fun arity)", pattern = "lfe", callback = _68_})
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
  local or_71_ = not run_visual.state.bufid
  if not or_71_ then
    local _72_ = vim.fn.bufexists
    or_71_ = ((0 == _72_) and (_72_ == run_visual.state.bufid))
  end
  if or_71_ then
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
local function _75_(_241)
  local function _77_(_76_)
    local fargs = _76_["fargs"]
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
        local _78_ = obj.code
        if (_78_ == 0) then
          text = obj.stdout
        elseif (nil ~= _78_) then
          local code = _78_
          local _80_
          do
            local _79_ = obj.stderr
            local and_81_ = (nil ~= _79_)
            if and_81_ then
              local v = _79_
              and_81_ = (v ~= "")
            end
            if and_81_ then
              local v = _79_
              _80_ = v
            else
              local _ = _79_
              _80_ = obj.stdout
            end
          end
          text = ("\240\159\146\128 Code: " .. code .. "\n" .. _80_)
        else
          text = nil
        end
      end
      local function _89_()
        local _87_, _88_ = string.gsub(text, "\27%[.-m", "")
        if ((nil ~= _87_) and true) then
          local a = _87_
          local _ = _88_
          return a
        else
          return nil
        end
      end
      return run_visual.buffer_append(vim.fn.split(vim.fn.trim(_89_()), "\n", true))
    end
    local function _91_(_2410)
      return vim.schedule_wrap(print_cmd_result)(_2410)
    end
    return vim.system(cmd, {text = true}, _91_)
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "RunVisual", _77_, {nargs = "+", range = true})
end
vim.api.nvim_create_autocmd("BufWinEnter", {desc = "create `RunVisual` usercommand", callback = _75_})
local function _92_(_241)
  return create_keymaps_for_goto_entry("\\v^# \\-+$", "[e", "]e", "run_visual_log", _241.buf)
end
return vim.api.nvim_create_autocmd("FileType", {desc = "[RunVisual] add keymaps for goto prev/next log", pattern = "RunVisual", callback = _92_})
