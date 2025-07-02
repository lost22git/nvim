-- [nfnl] fnl/core/run_visual.fnl
local _local_1_ = require("core.utils")
local create_keymaps_for_goto_entry = _local_1_["create_keymaps_for_goto_entry"]
local get_last_selection_text = _local_1_["get_last_selection_text"]
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
run_visual.write_selection_to_tmp_file = function()
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
  local or_4_ = not run_visual.state.bufid
  if not or_4_ then
    local _5_ = vim.fn.bufexists
    or_4_ = ((0 == _5_) and (_5_ == run_visual.state.bufid))
  end
  if or_4_ then
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
local function _8_(_241)
  local function _10_(_9_)
    local fargs = _9_["fargs"]
    local tmp_file = run_visual.write_selection_to_tmp_file()
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
        local _11_ = obj.code
        if (_11_ == 0) then
          text = obj.stdout
        elseif (nil ~= _11_) then
          local code = _11_
          local _13_
          do
            local _12_ = obj.stderr
            local and_14_ = (nil ~= _12_)
            if and_14_ then
              local v = _12_
              and_14_ = (v ~= "")
            end
            if and_14_ then
              local v = _12_
              _13_ = v
            else
              local _ = _12_
              _13_ = obj.stdout
            end
          end
          text = ("\240\159\146\128 Code: " .. code .. "\n" .. _13_)
        else
          text = nil
        end
      end
      local function _22_()
        local _20_, _21_ = string.gsub(text, "\27%[.-m", "")
        if ((nil ~= _20_) and true) then
          local a = _20_
          local _ = _21_
          return a
        else
          return nil
        end
      end
      return run_visual.buffer_append(vim.fn.split(vim.fn.trim(_22_()), "\n", true))
    end
    local function _24_(_2410)
      return vim.schedule_wrap(print_cmd_result)(_2410)
    end
    return vim.system(cmd, {text = true}, _24_)
  end
  return vim.api.nvim_buf_create_user_command(_241.buf, "RunVisual", _10_, {nargs = "+", range = true})
end
vim.api.nvim_create_autocmd("BufWinEnter", {desc = "Create [RunVisual] usercommand", callback = _8_})
local function _25_(_241)
  return create_keymaps_for_goto_entry("\\v^# \\-+$", "[e", "]e", "run_visual_log", _241.buf)
end
return vim.api.nvim_create_autocmd("FileType", {desc = "[RunVisual] add keymaps for goto prev/next log", pattern = "RunVisual", callback = _25_})
