-- [nfnl] fnl/lz/plugins/hover.fnl
local nvim_help
local function _2_(_1_)
  local text = _1_["text"]
  return vim.cmd(("help " .. text))
end
nvim_help = {name = "[hover] nvim help", event = "FileType", pattern = {"lua", "fennel"}, key = "<Leader>K", mode = {"n", "v"}, run = _2_}
local arturo_info
local function _4_(_3_)
  local text = _3_["text"]
  local open_hover_window = _3_["open_hover_window"]
  local cmd = {"sh", "-c", ("echo \"info '" .. text .. "\" | arturo --no-color")}
  print(table.concat(cmd, " "))
  local function on_exit(res, cmd0, open_hover_window0)
    local out
    local function _9_()
      local _5_, _6_ = nil, nil
      local _7_
      if (res.stderr == "") then
        _7_ = res.stdout
      else
        _7_ = res.stderr
      end
      _5_, _6_ = string.gsub(string.match(_7_, "(%$%>.+)%s*%$%>"), "\27%[.-m", "")
      if ((nil ~= _5_) and true) then
        local a = _5_
        local _ = _6_
        return a
      else
        return nil
      end
    end
    out = vim.fn.trim(_9_())
    local title = table.concat(cmd0, " ")
    local function cb(bufid, _winid)
      vim.bo[bufid]["filetype"] = "arturo"
      return nil
    end
    return open_hover_window0(out, title, cb)
  end
  local function _11_(_241)
    return vim.schedule_wrap(on_exit)(_241, cmd, open_hover_window)
  end
  return vim.system(cmd, {text = true}, _11_)
end
arturo_info = {name = "[hover] arturo info", event = "FileType", pattern = "arturo", key = "<Leader>k", mode = {"n", "v"}, run = _4_}
local lfe_info_fun
local function _13_(_12_)
  local text = _12_["text"]
  local open_hover_window = _12_["open_hover_window"]
  local cmd
  local function _14_()
    local _local_15_ = vim.split(text, ":")
    local m = _local_15_[1]
    local fa = _local_15_[2]
    local function _16_()
      if fa then
        return vim.split(fa, "/")
      else
        return {}
      end
    end
    local _local_17_ = _16_()
    local f = _local_17_[1]
    local a = _local_17_[2]
    local _18_
    if m then
      _18_ = (" '" .. m)
    else
      _18_ = ""
    end
    local _20_
    if f then
      _20_ = (" '" .. f)
    else
      _20_ = ""
    end
    local _22_
    if a then
      _22_ = (" " .. a)
    else
      _22_ = ""
    end
    return ("(h" .. _18_ .. _20_ .. _22_ .. ")")
  end
  cmd = {"lfe", "-e", _14_()}
  print(table.concat(cmd, " "))
  local function on_exit(res, cmd0, open_hover_window0)
    local out
    local function _28_()
      local _24_, _25_ = nil, nil
      local _26_
      if (res.stderr == "") then
        _26_ = res.stdout
      else
        _26_ = res.stderr
      end
      _24_, _25_ = string.gsub(_26_, "\27%[.-m", "")
      if ((nil ~= _24_) and true) then
        local a = _24_
        local _ = _25_
        return a
      else
        return nil
      end
    end
    out = vim.fn.trim(_28_())
    local title = table.concat(cmd0, " ")
    return open_hover_window0(out, title, nil)
  end
  local function _30_(_241)
    return vim.schedule_wrap(on_exit)(_241, cmd, open_hover_window)
  end
  return vim.system(cmd, {text = true, stdin = string.rep("y\n", 10)}, _30_)
end
lfe_info_fun = {name = "[hover] lfe (h mod fun arity)", event = "FileType", pattern = "lfe", key = "<Leader>k", mode = {"n", "v"}, run = _13_}
local lfe_info_mod
local function _32_(_31_)
  local text = _31_["text"]
  local open_hover_window = _31_["open_hover_window"]
  local cmd = {"lfe", "-e", ("(m '" .. text .. ")")}
  print(table.concat(cmd, " "))
  local function on_exit(res, cmd0, open_hover_window0)
    local out
    local function _37_()
      local _33_, _34_ = nil, nil
      local _35_
      if (res.stderr == "") then
        _35_ = res.stdout
      else
        _35_ = res.stderr
      end
      _33_, _34_ = string.gsub(_35_, "\27%[.-m", "")
      if ((nil ~= _33_) and true) then
        local a = _33_
        local _ = _34_
        return a
      else
        return nil
      end
    end
    out = vim.fn.trim(_37_())
    local title = table.concat(cmd0, " ")
    return open_hover_window0(out, title, nil)
  end
  local function _39_(_241)
    return vim.schedule_wrap(on_exit)(_241, cmd, open_hover_window)
  end
  return vim.system(cmd, {text = true, stdin = string.rep("y\n", 10)}, _39_)
end
lfe_info_mod = {name = "[hover] lfe (m mod)", event = "FileType", pattern = "lfe", key = "<Leader>K", mode = {"n", "v"}, run = _32_}
return {{"lost22git/hover.nvim", opts = {items = {nvim_help, arturo_info, lfe_info_fun, lfe_info_mod}}, lazy = false}}
