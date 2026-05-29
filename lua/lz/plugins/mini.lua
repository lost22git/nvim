-- [nfnl] fnl/lz/plugins/mini.fnl
local function _1_()
  require("mini.icons").setup()
  return MiniIcons.mock_nvim_web_devicons()
end
local function _2_()
  return require("mini.bufremove").setup({})
end
local function _3_()
  return MiniFiles.open()
end
local function _4_()
  return MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
end
return {{"nvim-mini/mini.icons", config = _1_, lazy = false}, {"nvim-mini/mini.cursorword", opts = {}, lazy = false}, {"nvim-mini/mini.move", opts = {}, lazy = false}, {"nvim-mini/mini.bufremove", config = _2_, lazy = false}, {"nvim-mini/mini.files", opts = {windows = {preview = true}}, keys = {{"<M-1>", _3_, desc = "[mini.files] Open"}, {"<M-2>", _4_, desc = "[mini.files] Open current directory"}}, lazy = false}}
