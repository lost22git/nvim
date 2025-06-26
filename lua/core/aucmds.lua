-- [nfnl] fnl/core/aucmds.fnl
local _local_1_ = require("core.utils")
local create_keymaps_for_goto_entry = _local_1_["create_keymaps_for_goto_entry"]
local on_v_modes = _local_1_["on_v_modes"]
local get_current_selection_text = _local_1_["get_current_selection_text"]
local get_last_selection_text = _local_1_["get_last_selection_text"]
local open_hover_window = _local_1_["open_hover_window"]
local GUI_CURSOR_CACHE = nil
local function _2_()
  GUI_CURSOR_CACHE = vim.opt.guicursor:get()
  vim.opt.guicursor = {}
  return vim.fn.chansend(vim.v.stderr, "\27[6 q \27[?12l")
end
vim.api.nvim_create_autocmd({"VimLeave", "VimSuspend"}, {desc = "Restore terminal cursor style", pattern = "*", callback = _2_})
local function _3_()
  if GUI_CURSOR_CACHE then
    vim.opt.guicursor = GUI_CURSOR_CACHE
    return nil
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("VimResume", {desc = "Restore nvim cursor style", pattern = "*", callback = _3_})
local function _5_()
  if (vim.bo.modifiable and not vim.tbl_contains({"qf", "FTerm"}, vim.bo.filetype)) then
    vim.bo.fileformat = "unix"
    return nil
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("FileType", {desc = "Set fileformat to unix", pattern = "*", callback = _5_})
local function _7_()
  return vim.hl.on_yank({higroup = "Visual", timeout = 200})
end
vim.api.nvim_create_autocmd("TextYankPost", {desc = "Highlight yanked text", pattern = "*", callback = _7_})
local function _8_()
  return vim.cmd("%s/\\s\\+$//e")
end
vim.api.nvim_create_autocmd("BufWritePre", {desc = "Remove trailing whitespace", callback = _8_})
local function _9_()
  return vim.cmd("silent! normal! g`\"zv")
end
vim.api.nvim_create_autocmd("BufReadPost", {desc = "Restore cursor position", callback = _9_})
local function _10_()
  vim.opt_local.buflisted = false
  return nil
end
vim.api.nvim_create_autocmd("FileType", {desc = "Do not list quickfix buffers", pattern = "qf", callback = _10_})
local function _11_(_241)
  return create_keymaps_for_goto_entry("[-\\/;#] === .\\+ ===$", "[r", "]r", "code_region", _241.buf)
end
vim.api.nvim_create_autocmd("BufWinEnter", {desc = "Add keymaps for Goto prev/next region", callback = _11_})
local function _12_(_241)
  return create_keymaps_for_goto_entry("\\v(^\\(comment|^#_)", "[C", "]C", "comment_form", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add keymaps for Goto prev/next (comment)", pattern = {"clojure", "janet"}, callback = _12_})
local function _13_(_241)
  return create_keymaps_for_goto_entry("\\v^\\w+.*:$", "[e", "]e", "just_task", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Just] add keymaps for Goto prev/next task", pattern = "just", callback = _13_})
local function _14_(_241)
  return create_keymaps_for_goto_entry("\\v^<(HEAD|GET|POST|PUT|PATCH|DELETE|OPTION)>", "[e", "]e", "http_request", _241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Http] add keymaps for Goto prev/next http request", pattern = {"http", "rest", "hurl"}, callback = _14_})
local function _15_()
  local function _17_(_16_)
    local args = _16_["args"]
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
  return vim.api.nvim_buf_create_user_command(0, "Clj", _17_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add `Clj` usercommand for starting Clojure nREPL server", pattern = "clojure", callback = _15_})
local function _19_(_241)
  local function _20_()
    return vim.cmd(("tabnew | term " .. "janet-netrepl"))
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "JanetNetrepl", _20_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Janet] add `JanetNetrepl` usercommand for starting janet-netrepl server", pattern = "janet", callback = _19_})
local function nvim_help()
  local q
  if on_v_modes() then
    q = get_current_selection_text()
  else
    q = vim.fn.expand("<cword>")
  end
  return vim.cmd(("help " .. q))
end
local function _23_(_22_)
  local bufid = _22_["buf"]
  local function cb()
    if (1 == vim.fn.bufexists(bufid)) then
      return vim.keymap.set({"n", "v"}, "<Leader>k", nvim_help, {buffer = bufid, desc = "[base] Nvim help"})
    else
      return nil
    end
  end
  return vim.defer_fn(cb, 1000)
end
vim.api.nvim_create_autocmd("FileType", {desc = "Add keymaps for nvim help", pattern = "lua", callback = _23_})
local add_keymaps_for_docr = nil
local function docr(subcmd)
  local function make_cmd(q)
    return {"docr", subcmd, ("'" .. vim.fn.escape(q, "'") .. "'")}
  end
  local function process_content(content)
    local function _27_()
      local _25_, _26_ = string.gsub(content, "\27%[.-m", "")
      if ((nil ~= _25_) and true) then
        local a = _25_
        local _ = _26_
        return a
      else
        return nil
      end
    end
    return vim.fn.trim(_27_())
  end
  local function open_doc_window(content, title)
    local text = process_content(content)
    local function _29_(bufid, _winid)
      vim.bo[bufid]["filetype"] = "markdown"
      return add_keymaps_for_docr(bufid)
    end
    return open_hover_window(text, title, _29_)
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
  local function _31_(res)
    print("")
    if ((0 ~= res.code) or not res.stdout or ("" == res.stdout)) then
      return vim.print(cmd_str, res)
    else
      return vim.schedule_wrap(open_doc_window)(res.stdout, cmd_str)
    end
  end
  return vim.system(cmd, {text = true}, _31_)
end
local function _33_(bufid)
  local function _34_(...)
    return docr("info", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>k", _34_, {buffer = bufid, desc = "[base] docr info"})
  local function _35_(...)
    return docr("search", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>K", _35_, {buffer = bufid, desc = "[base] docr search"})
  local function _36_(...)
    return docr("tree", ...)
  end
  return vim.keymap.set({"n", "v"}, "<Leader>kk", _36_, {buffer = bufid, desc = "[base] docr tree"})
end
add_keymaps_for_docr = _33_
local function _37_(_241)
  return add_keymaps_for_docr(_241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Crystal] add keymaps for docr", pattern = "crystal", callback = _37_})
local function arturo_doc(subcmd)
  local function make_cmd(q)
    return {"sh", "-c", ("echo \"info '" .. q .. "\" | arturo --no-color")}
  end
  local function process_content(content)
    local function _40_()
      local _38_, _39_ = string.gsub(string.match(content, "(%$%>.+)%s*%$%>"), "\27%[.-m", "")
      if ((nil ~= _38_) and true) then
        local a = _38_
        local _ = _39_
        return a
      else
        return nil
      end
    end
    return vim.fn.trim(_40_())
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
  local function _43_(res)
    print("")
    if ((0 ~= res.code) or not res.stdout or ("" == res.stdout)) then
      return vim.print(cmd_str, res)
    else
      return vim.schedule_wrap(open_doc_window)(res.stdout, cmd_str)
    end
  end
  return vim.system(cmd, {text = true}, _43_)
end
local function add_keymaps_for_arturo_doc(bufid)
  local function _45_(...)
    return arturo_doc("info", ...)
  end
  return vim.keymap.set({"n", "v"}, "<Leader>k", _45_, {buffer = bufid, desc = "[base] arturo info"})
end
local function _46_(_241)
  return add_keymaps_for_arturo_doc(_241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Arturo] add keymaps for arturo doc", pattern = "arturo", callback = _46_})
local function lfe_doc(m_or_h)
  local function make_cmd(q)
    local qq
    if (m_or_h == "m") then
      qq = ("(m '" .. q .. ")")
    elseif (m_or_h == "h") then
      local _local_47_ = vim.split(q, ":")
      local m = _local_47_[1]
      local fa = _local_47_[2]
      local function _48_()
        if fa then
          return vim.split(fa, "/")
        else
          return {}
        end
      end
      local _local_49_ = _48_()
      local f = _local_49_[1]
      local a = _local_49_[2]
      local _50_
      if m then
        _50_ = (" '" .. m)
      else
        _50_ = ""
      end
      local _52_
      if f then
        _52_ = (" '" .. f)
      else
        _52_ = ""
      end
      local _54_
      if a then
        _54_ = (" " .. a)
      else
        _54_ = ""
      end
      qq = ("(h" .. _50_ .. _52_ .. _54_ .. ")")
    else
      qq = nil
    end
    return {"lfe", "-e", qq}
  end
  local function process_content(content)
    local function _59_()
      local _57_, _58_ = string.gsub(content, "\27%[.-m", "")
      if ((nil ~= _57_) and true) then
        local a = _57_
        local _ = _58_
        return a
      else
        return nil
      end
    end
    return vim.fn.trim(_59_())
  end
  local function open_doc_window(content, title)
    local text = process_content(content)
    local function _61_(bufid, _winid)
      vim.bo[bufid]["filetype"] = "markdown"
      return nil
    end
    return open_hover_window(text, title, _61_)
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
  local function _63_(res)
    print("")
    if ((0 ~= res.code) or not res.stdout or ("" == res.stdout)) then
      return vim.print(cmd_str, res)
    else
      return vim.schedule_wrap(open_doc_window)(res.stdout, cmd_str)
    end
  end
  return vim.system(cmd, {text = true, stdin = string.rep("y\n", 10)}, _63_)
end
local function add_keymaps_for_lfe_doc(bufid)
  local function _65_(...)
    return lfe_doc("h", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>k", _65_, {buffer = bufid, desc = "[base] lfe (h mod fun arity)"})
  local function _66_(...)
    return lfe_doc("m", ...)
  end
  return vim.keymap.set({"n", "v"}, "<Leader>K", _66_, {buffer = bufid, desc = "[base] lfe (m mod)"})
end
local function _67_(_241)
  return add_keymaps_for_lfe_doc(_241.buf)
end
vim.api.nvim_create_autocmd("FileType", {desc = "[LFE] add keymaps for (m mode) or (h mod fun arity)", pattern = "lfe", callback = _67_})
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
  local or_70_ = not run_visual.state.bufid
  if not or_70_ then
    local _71_ = vim.fn.bufexists
    or_70_ = ((0 == _71_) and (_71_ == run_visual.state.bufid))
  end
  if or_70_ then
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
local function _74_(_241)
  local function _76_(_75_)
    local fargs = _75_["fargs"]
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
        local _77_ = obj.code
        if (_77_ == 0) then
          text = obj.stdout
        elseif (nil ~= _77_) then
          local code = _77_
          local _79_
          do
            local _78_ = obj.stderr
            local and_80_ = (nil ~= _78_)
            if and_80_ then
              local v = _78_
              and_80_ = (v ~= "")
            end
            if and_80_ then
              local v = _78_
              _79_ = v
            else
              local _ = _78_
              _79_ = obj.stdout
            end
          end
          text = ("\240\159\146\128 Code: " .. code .. "\n" .. _79_)
        else
          text = nil
        end
      end
      local function _88_()
        local _86_, _87_ = string.gsub(text, "\27%[.-m", "")
        if ((nil ~= _86_) and true) then
          local a = _86_
          local _ = _87_
          return a
        else
          return nil
        end
      end
      return run_visual.buffer_append(vim.fn.split(vim.fn.trim(_88_()), "\n", true))
    end
    local function _90_(_2410)
      return vim.schedule_wrap(print_cmd_result)(_2410)
    end
    return vim.system(cmd, {text = true}, _90_)
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "RunVisual", _76_, {nargs = "+", range = true})
end
vim.api.nvim_create_autocmd("BufWinEnter", {desc = "create `RunVisual` usercommand", callback = _74_})
local function _91_(_241)
  return create_keymaps_for_goto_entry("\\v^# \\-+$", "[e", "]e", "run_visual_log", _241.buf)
end
return vim.api.nvim_create_autocmd("FileType", {desc = "[RunVisual] add keymaps for goto prev/next log", pattern = "RunVisual", callback = _91_})
