-- [nfnl] fnl/core/aucmds.fnl
local _local_1_ = require("core.utils")
local create_keymaps_for_goto_entry = _local_1_["create_keymaps_for_goto_entry"]
local on_v_modes = _local_1_["on_v_modes"]
local get_current_selection_text = _local_1_["get_current_selection_text"]
local get_last_selection_text = _local_1_["get_last_selection_text"]
local open_hover_window = _local_1_["open_hover_window"]
local function _2_()
  if (vim.bo.modifiable and not vim.tbl_contains({"qf", "FTerm"}, vim.bo.filetype)) then
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
  return vim.cmd("%s/\\s\\+$//e")
end
vim.api.nvim_create_autocmd("BufWritePre", {desc = "Remove trailing whitespace", callback = _5_})
local function _6_()
  return vim.cmd("silent! normal! g`\"zv")
end
vim.api.nvim_create_autocmd("BufReadPost", {desc = "Restore cursor position", callback = _6_})
local function _7_()
  vim.opt_local.buflisted = false
  return nil
end
vim.api.nvim_create_autocmd("FileType", {desc = "Do not list quickfix buffers", pattern = "qf", callback = _7_})
local function _8_(_241)
  return create_keymaps_for_goto_entry("[-\\/;#] === .\\+ ===$", "[r", "]r", "code_region", _241.buf)
end
vim.api.nvim_create_autocmd("BufWinEnter", {desc = "Add keymaps for Goto prev/next region", callback = _8_})
local GUI_CURSOR_CACHE = nil
local function _9_()
  GUI_CURSOR_CACHE = vim.opt.guicursor:get()
  vim.opt.guicursor = {}
  vim.fn.chansend(vim.v.stderr, "\27[6 q \27[?12l")
  return nil
end
vim.api.nvim_create_autocmd({"VimLeave", "VimSuspend"}, {desc = "Restore terminal cursor style", pattern = "*", callback = _9_})
local function _10_()
  if GUI_CURSOR_CACHE then
    vim.opt.guicursor = GUI_CURSOR_CACHE
    return nil
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("VimResume", {desc = "Restore nvim cursor style", pattern = "*", callback = _10_})
local _13_
do
  local t_12_ = vim.env
  if (nil ~= t_12_) then
    t_12_ = t_12_.TMUX
  else
  end
  _13_ = t_12_
end
if _13_ then
  local function _15_(_241)
    local cmd = ("tmux source-file " .. vim.api.nvim_buf_get_name(_241.buf))
    vim.fn.system(cmd)
    return nil
  end
  vim.api.nvim_create_autocmd("BufWritePost", {desc = "Reload tmux config after [.tmux.conf] saved", pattern = ".tmux.conf", callback = _15_})
else
end
local function _17_(_241)
  return create_keymaps_for_goto_entry("\\v^\\w+.*:$", "[e", "]e", "just_task", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Just] add keymaps for Goto prev/next task", pattern = "just", callback = _17_})
local function _18_(_241)
  return create_keymaps_for_goto_entry("\\v^<(HEAD|GET|POST|PUT|PATCH|DELETE|OPTION)>", "[e", "]e", "http_request", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Http] add keymaps for Goto prev/next http request", pattern = {"http", "rest", "hurl"}, callback = _18_})
local function _19_(_241)
  return create_keymaps_for_goto_entry("\\v(^\\(comment|^#_)", "[C", "]C", "comment_form", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add keymaps for Goto prev/next (comment)", pattern = {"clojure", "janet"}, callback = _19_})
local function _20_()
  local function _22_(_21_)
    local args = _21_["args"]
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
  return vim.api.nvim_buf_create_user_command(0, "Clj", _22_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add `Clj` usercommand for starting Clojure nREPL server", pattern = "clojure", callback = _20_})
local function _24_(_241)
  local function _25_()
    return vim.cmd(("tabnew | term " .. "janet-netrepl"))
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "JanetNetrepl", _25_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Janet] add `JanetNetrepl` usercommand for starting janet-netrepl server", pattern = "janet", callback = _24_})
local function nvim_help()
  local q
  if on_v_modes() then
    q = get_current_selection_text()
  else
    q = vim.fn.expand("<cword>")
  end
  return vim.cmd(("help " .. q))
end
local function _28_(_27_)
  local bufid = _27_["buf"]
  local function cb()
    if (1 == vim.fn.bufexists(bufid)) then
      return vim.keymap.set({"n", "v"}, "<Leader>k", nvim_help, {buffer = bufid, desc = "[base] Nvim help"})
    else
      return nil
    end
  end
  return vim.defer_fn(cb, 1000)
end
vim.api.nvim_create_autocmd("FileType", {desc = "Add keymaps for nvim help", pattern = "lua", callback = _28_})
local add_keymaps_for_docr = nil
local function docr(subcmd)
  local function make_cmd(q)
    return {"docr", subcmd, ("'" .. vim.fn.escape(q, "'") .. "'")}
  end
  local function process_content(content)
    local function _32_()
      local _30_, _31_ = string.gsub(content, "\27%[.-m", "")
      if ((nil ~= _30_) and true) then
        local a = _30_
        local _ = _31_
        return a
      else
        return nil
      end
    end
    return vim.fn.trim(_32_())
  end
  local function open_doc_window(content, title)
    local text = process_content(content)
    local function _34_(bufid, _winid)
      vim.bo[bufid]["filetype"] = "markdown"
      return add_keymaps_for_docr(bufid)
    end
    return open_hover_window(text, title, _34_)
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
  local function _36_(res)
    print("")
    if ((0 ~= res.code) or not res.stdout or ("" == res.stdout)) then
      return vim.print(cmd_str, res)
    else
      return vim.schedule_wrap(open_doc_window)(res.stdout, cmd_str)
    end
  end
  return vim.system(cmd, {text = true}, _36_)
end
local function _38_(bufid)
  local function _39_(...)
    return docr("info", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>k", _39_, {buffer = bufid, desc = "[base] docr info"})
  local function _40_(...)
    return docr("search", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>K", _40_, {buffer = bufid, desc = "[base] docr search"})
  local function _41_(...)
    return docr("tree", ...)
  end
  return vim.keymap.set({"n", "v"}, "<Leader>kk", _41_, {buffer = bufid, desc = "[base] docr tree"})
end
add_keymaps_for_docr = _38_
local function _42_(_241)
  return add_keymaps_for_docr(_241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Crystal] add keymaps for docr", pattern = "crystal", callback = _42_})
local function arturo_doc(subcmd)
  local function make_cmd(q)
    return {"sh", "-c", ("echo \"info '" .. q .. "\" | arturo --no-color")}
  end
  local function process_content(content)
    local function _45_()
      local _43_, _44_ = string.gsub(string.match(content, "(%$%>.+)%s*%$%>"), "\27%[.-m", "")
      if ((nil ~= _43_) and true) then
        local a = _43_
        local _ = _44_
        return a
      else
        return nil
      end
    end
    return vim.fn.trim(_45_())
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
  local function _48_(res)
    print("")
    if ((0 ~= res.code) or not res.stdout or ("" == res.stdout)) then
      return vim.print(cmd_str, res)
    else
      return vim.schedule_wrap(open_doc_window)(res.stdout, cmd_str)
    end
  end
  return vim.system(cmd, {text = true}, _48_)
end
local function add_keymaps_for_arturo_doc(bufid)
  local function _50_(...)
    return arturo_doc("info", ...)
  end
  return vim.keymap.set({"n", "v"}, "<Leader>k", _50_, {buffer = bufid, desc = "[base] arturo info"})
end
local function _51_(_241)
  return add_keymaps_for_arturo_doc(_241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Arturo] add keymaps for arturo doc", pattern = "arturo", callback = _51_})
local function lfe_doc(m_or_h)
  local function make_cmd(q)
    local qq
    if (m_or_h == "m") then
      qq = ("(m '" .. q .. ")")
    elseif (m_or_h == "h") then
      local _local_52_ = vim.split(q, ":")
      local m = _local_52_[1]
      local fa = _local_52_[2]
      local function _53_()
        if fa then
          return vim.split(fa, "/")
        else
          return {}
        end
      end
      local _local_54_ = _53_()
      local f = _local_54_[1]
      local a = _local_54_[2]
      local _55_
      if m then
        _55_ = (" '" .. m)
      else
        _55_ = ""
      end
      local _57_
      if f then
        _57_ = (" '" .. f)
      else
        _57_ = ""
      end
      local _59_
      if a then
        _59_ = (" " .. a)
      else
        _59_ = ""
      end
      qq = ("(h" .. _55_ .. _57_ .. _59_ .. ")")
    else
      qq = nil
    end
    return {"lfe", "-e", qq}
  end
  local function process_content(content)
    local function _64_()
      local _62_, _63_ = string.gsub(content, "\27%[.-m", "")
      if ((nil ~= _62_) and true) then
        local a = _62_
        local _ = _63_
        return a
      else
        return nil
      end
    end
    return vim.fn.trim(_64_())
  end
  local function open_doc_window(content, title)
    local text = process_content(content)
    local function _66_(bufid, _winid)
      vim.bo[bufid]["filetype"] = "markdown"
      return nil
    end
    return open_hover_window(text, title, _66_)
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
  local function _68_(res)
    print("")
    if ((0 ~= res.code) or not res.stdout or ("" == res.stdout)) then
      return vim.print(cmd_str, res)
    else
      return vim.schedule_wrap(open_doc_window)(res.stdout, cmd_str)
    end
  end
  return vim.system(cmd, {text = true, stdin = string.rep("y\n", 10)}, _68_)
end
local function add_keymaps_for_lfe_doc(bufid)
  local function _70_(...)
    return lfe_doc("h", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>k", _70_, {buffer = bufid, desc = "[base] lfe (h mod fun arity)"})
  local function _71_(...)
    return lfe_doc("m", ...)
  end
  return vim.keymap.set({"n", "v"}, "<Leader>K", _71_, {buffer = bufid, desc = "[base] lfe (m mod)"})
end
local function _72_(_241)
  return add_keymaps_for_lfe_doc(_241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[LFE] add keymaps for (m mode) or (h mod fun arity)", pattern = "lfe", callback = _72_})
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
  local or_75_ = not run_visual.state.bufid
  if not or_75_ then
    local _76_ = vim.fn.bufexists
    or_75_ = ((0 == _76_) and (_76_ == run_visual.state.bufid))
  end
  if or_75_ then
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
local function _79_(_241)
  local function _81_(_80_)
    local fargs = _80_["fargs"]
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
        local _82_ = obj.code
        if (_82_ == 0) then
          text = obj.stdout
        elseif (nil ~= _82_) then
          local code = _82_
          local _84_
          do
            local _83_ = obj.stderr
            local and_85_ = (nil ~= _83_)
            if and_85_ then
              local v = _83_
              and_85_ = (v ~= "")
            end
            if and_85_ then
              local v = _83_
              _84_ = v
            else
              local _ = _83_
              _84_ = obj.stdout
            end
          end
          text = ("\240\159\146\128 Code: " .. code .. "\n" .. _84_)
        else
          text = nil
        end
      end
      local function _93_()
        local _91_, _92_ = string.gsub(text, "\27%[.-m", "")
        if ((nil ~= _91_) and true) then
          local a = _91_
          local _ = _92_
          return a
        else
          return nil
        end
      end
      return run_visual.buffer_append(vim.fn.split(vim.fn.trim(_93_()), "\n", true))
    end
    local function _95_(_2410)
      return vim.schedule_wrap(print_cmd_result)(_2410)
    end
    return vim.system(cmd, {text = true}, _95_)
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "RunVisual", _81_, {nargs = "+", range = true})
end
vim.api.nvim_create_autocmd("BufWinEnter", {desc = "create `RunVisual` usercommand", callback = _79_})
local function _96_(_241)
  return create_keymaps_for_goto_entry("\\v^# \\-+$", "[e", "]e", "run_visual_log", _241.buf)
end
return vim.api.nvim_create_autocmd("FileType", {desc = "[RunVisual] add keymaps for goto prev/next log", pattern = "RunVisual", callback = _96_})
