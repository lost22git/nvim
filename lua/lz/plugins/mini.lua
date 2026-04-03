-- [nfnl] fnl/lz/plugins/mini.fnl
local function _1_()
  require("mini.icons").setup()
  return MiniIcons.mock_nvim_web_devicons()
end
local function _2_()
  local _local_3_ = require("mini.ai")
  local setup = _local_3_.setup
  local gen_spec = _local_3_.gen_spec
  return setup({mappings = {around = "a", inside = "i", around_next = "a]", inside_next = "i]", around_last = "a[", inside_last = "i[", goto_left = "[", goto_right = "]"}})
end
local function _4_()
  return MiniFiles.open()
end
local function _5_()
  return MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
end
return {{"nvim-mini/mini.icons", config = _1_, lazy = false}, {"nvim-mini/mini.cursorword", opts = {}, lazy = false}, {"nvim-mini/mini.move", opts = {}, lazy = false}, {"nvim-mini/mini.ai", config = _2_, lazy = false}, {"nvim-mini/mini.bufremove", opts = {}, lazy = false}, {"nvim-mini/mini.files", opts = {windows = {preview = true}}, keys = {{"<M-1>", _4_, desc = "[mini.files] Open"}, {"<M-2>", _5_, desc = "[mini.files] Open current directory"}}, lazy = false}}
