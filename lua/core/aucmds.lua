-- [nfnl] fnl/core/aucmds.fnl
vim.cmd("\n  au BufNewFile,BufReadPost *.bb set filetype=clojure\n  au BufNewFile,BufReadPost *.c3 set filetype=c3\n  au BufNewFile,BufReadPost *.cljd set filetype=clojure\n  au BufNewFile,BufReadPost *.cy set filetype=cyber\n  au BufNewFile,BufReadPost *.http set filetype=http\n  au BufNewFile,BufReadPost *.kk set filetype=koka\n  au BufNewFile,BufReadPost *.lfe set filetype=lfe\n  au BufNewFile,BufReadPost *.lobster set filetype=lobster\n  au BufNewFile,BufReadPost *.postcss set filetype=postcss\n  au BufNewFile,BufReadPost *.v set filetype=vlang\n")
vim.cmd("\n  au FileType c3 setlocal commentstring=//\\ %s\n  au FileType cyber setlocal commentstring=--\\ %s\n  au FileType http setlocal commentstring=#\\ %s\n  au FileType inko setlocal commentstring=#\\ %s\n  au FileType janet setlocal commentstring=#\\ %s\n  au FileType json setlocal commentstring=//\\ %s\n  au FileType just setlocal commentstring=#\\ %s\n  au FileType koka setlocal commentstring=//\\ %s\n  au FileType lfe setlocal commentstring=;\\ %s\n  au FileType lobster setlocal commentstring=//\\ %s\n")
local _2_
do
  local t_1_ = vim.env
  if (nil ~= t_1_) then
    t_1_ = t_1_.TMUX
  else
  end
  _2_ = t_1_
end
if _2_ then
  vim.cmd("\n    augroup tmux_status_bar_toggle\n      autocmd VimEnter,VimResume  * call system('tmux set status off')\n      autocmd VimLeave,VimSuspend * call system('tmux set status on')\n    augroup END\n  ")
else
end
local GUI_CURSOR_CACHE = nil
local function _5_()
  GUI_CURSOR_CACHE = vim.opt.guicursor:get()
  vim.opt.guicursor = {}
  return vim.fn.chansend(vim.v.stderr, "\27[6 q \27[?12l")
end
vim.api.nvim_create_autocmd({"VimLeave", "VimSuspend"}, {desc = "restore terminal cursor style", pattern = "*", callback = _5_})
local function _6_()
  if GUI_CURSOR_CACHE then
    vim.opt.guicursor = GUI_CURSOR_CACHE
    return nil
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("VimResume", {desc = "restore nvim cursor style", pattern = "*", callback = _6_})
local function _8_()
  if (vim.bo.modifiable and not vim.tbl_contains({"qf", "FTerm"}, vim.bo.filetype)) then
    vim.bo.fileformat = "unix"
    return nil
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("FileType", {desc = "set fileformat to unix", pattern = "*", callback = _8_})
local function _10_()
  return vim.hl.on_yank({higroup = "Visual", timeout = 200})
end
vim.api.nvim_create_autocmd("TextYankPost", {desc = "highlight yanked text", pattern = "*", callback = _10_})
local function _11_(ev)
  local p = "[-\\/;#] === .\\+ ===$"
  vim.keymap.set({"n", "v", "o"}, "[r", string.format("<Cmd>call search('%s','bw')<CR>", p), {silent = true, buffer = ev.buf, desc = "[base] Goto prev region"})
  return vim.keymap.set({"n", "v", "o"}, "]r", string.format("<Cmd>call search('%s','w')<CR>", p), {silent = true, buffer = ev.buf, desc = "[base] Goto next region"})
end
vim.api.nvim_create_autocmd("BufWinEnter", {desc = "add keymaps for Goto prev/next region", callback = _11_})
local function _12_(ev)
  local p = "\\v(^\\(comment|^#_)"
  vim.keymap.set({"n", "v", "o"}, "[C", string.format("<Cmd>call search('%s','bw')<CR>", p), {silent = true, buffer = ev.buf, desc = "[base] Clojure goto prev comment"})
  return vim.keymap.set({"n", "v", "o"}, "]C", string.format("<Cmd>call search('%s','w')<CR>", p), {silent = true, buffer = ev.buf, desc = "[base] Clojure goto next comment"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add keymaps for Goto prev/next (comment)", pattern = {"clojure", "janet"}, callback = _12_})
local function _13_(ev)
  local p = "\\v^\\w+.*:$"
  vim.keymap.set({"n", "v", "o"}, "[e", string.format("<Cmd>call search('%s','bw')<CR>", p), {silent = true, buffer = ev.buf, desc = "[base] Justfile goto prev task"})
  return vim.keymap.set({"n", "v", "o"}, "]e", string.format("<Cmd>call search('%s','w')<CR>", p), {silent = true, buffer = ev.buf, desc = "[base] Justfile goto next task"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Just] add keymaps for Goto prev/next task", pattern = "just", callback = _13_})
local function nvim_help()
  local _local_14_ = require("core.utils")
  local on_v_modes = _local_14_["on_v_modes"]
  local get_current_selection_text = _local_14_["get_current_selection_text"]
  local q
  if on_v_modes() then
    q = get_current_selection_text()
  else
    q = vim.fn.expand("<cword>")
  end
  return vim.cmd(("help " .. q))
end
local function _16_(ev)
  local function cb()
    if (1 == vim.fn.bufexists(ev.buf)) then
      return vim.keymap.set({"n", "v"}, "<Leader>k", nvim_help, {buffer = ev.buf, desc = "[base] Nvim help"})
    else
      return nil
    end
  end
  return vim.defer_fn(cb, 1000)
end
vim.api.nvim_create_autocmd("FileType", {desc = "add keymaps for nvim help", pattern = "lua", callback = _16_})
local add_keymaps_for_docr = nil
local function docr(subcmd)
  local function open_doc_window(obj, title)
    print("")
    local text = vim.fn.trim(assert(obj.stdout))
    local _local_18_ = require("core.utils")
    local open_hover_window = _local_18_["open_hover_window"]
    local function _19_(bufid, _winid)
      vim.bo[bufid]["filetype"] = "markdown"
      return add_keymaps_for_docr(bufid)
    end
    return open_hover_window(text, title, _19_)
  end
  local _local_20_ = require("core.utils")
  local on_v_modes = _local_20_["on_v_modes"]
  local get_current_selection_text = _local_20_["get_current_selection_text"]
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
    local _local_29_ = require("core.utils")
    local open_hover_window = _local_29_["open_hover_window"]
    local function _30_(bufid, _winid)
      vim.bo[bufid]["filetype"] = "markdown"
      return nil
    end
    return open_hover_window(text, title, _30_)
  end
  local function make_cmd(q)
    local qq
    if (m_or_h == "m") then
      qq = ("(m '" .. q .. ")")
    elseif (m_or_h == "h") then
      local _local_31_ = vim.split(q, ":")
      local m = _local_31_[1]
      local fa = _local_31_[2]
      local function _32_()
        if fa then
          return vim.split(fa, "/")
        else
          return {}
        end
      end
      local _local_33_ = _32_()
      local f = _local_33_[1]
      local a = _local_33_[2]
      local _34_
      if m then
        _34_ = (" '" .. m)
      else
        _34_ = ""
      end
      local _36_
      if f then
        _36_ = (" '" .. f)
      else
        _36_ = ""
      end
      local _38_
      if a then
        _38_ = (" " .. a)
      else
        _38_ = ""
      end
      qq = ("(h" .. _34_ .. _36_ .. _38_ .. ")")
    else
      qq = nil
    end
    return {"lfe", "-e", qq}
  end
  local _local_41_ = require("core.utils")
  local on_v_modes = _local_41_["on_v_modes"]
  local get_current_selection_text = _local_41_["get_current_selection_text"]
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
    if ((0 ~= res.code) or not res.stdout or ("" == res.stdout)) then
      return vim.print(cmd_str, res)
    else
      return vim.schedule_wrap(open_doc_window)(res, cmd_str)
    end
  end
  return vim.system(cmd, {text = true, stdin = string.rep("y\n", 10)}, _43_)
end
local function _45_(ev)
  local function _46_(...)
    return lfe_doc("h", ...)
  end
  vim.keymap.set({"n", "v"}, "<Leader>k", _46_, {buffer = ev.buf, desc = "[base] lfe (h mod fun arity)"})
  local function _47_(...)
    return lfe_doc("m", ...)
  end
  return vim.keymap.set({"n", "v"}, "<Leader>K", _47_, {buffer = ev.buf, desc = "[base] lfe (m mod)"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[LFE] add keymaps for (m mode) or (h mod fun arity)", pattern = "lfe", callback = _45_})
local function _48_()
  local function _49_(opts)
    local clj_opts
    if string.match(opts.args, "%-M:") then
      clj_opts = opts.args
    else
      clj_opts = (opts.args .. " " .. "-M")
    end
    local deps = "'{:deps {nrepl/nrepl {:mvn/version \"1.3.0\"} refactor-nrepl/refactor-nrepl {:mvn/version \"3.10.0\"} cider/cider-nrepl {:mvn/version \"0.52.0\"} }}'"
    local cider_opts = "\"(require 'nrepl.cmdline) (nrepl.cmdline/-main \\\"--interactive\\\" \\\"--middleware\\\" \\\"[refactor-nrepl.middleware/wrap-refactor cider.nrepl/cider-middleware]\\\")\""
    local command = string.format("clj -Sdeps %s %s -e %s", deps, clj_opts, cider_opts)
    return vim.cmd(("tabnew | term " .. command))
  end
  return vim.api.nvim_buf_create_user_command(0, "Clj", _49_, {nargs = "*"})
end
vim.api.nvim_create_autocmd("FileType", {desc = "[Clojure] add `Clj` usercommand for starting Clojure nREPL server", pattern = "clojure", callback = _48_})
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
  vim.api.nvim_buf_set_lines(bufid, vim.api.nvim_buf_line_count(bufid), -1, false, lines)
  return vim.api.nvim_win_set_cursor(winid, {vim.api.nvim_buf_line_count(bufid), 0})
end
run_visual.read_selection_and_write_to_tmp_file = function()
  local _local_53_ = require("core.utils")
  local get_last_selection_text = _local_53_["get_last_selection_text"]
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
  else
  end
  if not (run_visual.state.winid and vim.api.nvim_win_is_valid(run_visual.state.winid)) then
    run_visual.state.winid = vim.api.nvim_open_win(run_visual.state.bufid, false, {split = "below"})
    return nil
  else
    return nil
  end
end
local function _59_(_241)
  local function _60_(opts)
    local tmp_file = run_visual.read_selection_and_write_to_tmp_file()
    local cmd = {unpack(opts.fargs), tmp_file}
    run_visual.ensure_buf_and_win()
    do
      local time_str = os.date("!%m-%d %H:%M:%S", os.time())
      local title_lines = {string.rep("-", 80), (time_str .. " - " .. table.concat(cmd, " ")), string.rep("-", 80)}
      run_visual.buffer_append(title_lines)
    end
    local function _61_(obj)
      local function print_cmd_result()
        local text
        if (obj.stdout and (obj.stdout ~= "")) then
          text = obj.stdout
        else
          text = vim.inspect(obj)
        end
        return run_visual.buffer_append(vim.fn.split(text, "\n", true))
      end
      return vim.schedule_wrap(print_cmd_result)()
    end
    return vim.system(cmd, {text = true}, _61_)
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "RunVisual", _60_, {nargs = "+", range = true})
end
return vim.api.nvim_create_autocmd("BufWinEnter", {desc = "create `RunVisual` usercommand", callback = _59_})
