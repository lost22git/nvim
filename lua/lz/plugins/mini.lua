-- [nfnl] fnl/lz/plugins/mini.fnl
local function _1_()
  require("mini.icons").setup()
  return MiniIcons.mock_nvim_web_devicons()
end
local function _2_()
  local _local_3_ = require("mini.ai")
  local setup = _local_3_.setup
  local gen_spec = _local_3_.gen_spec
  local _local_4_ = require("mini.extra")
  local gen_ai_spec = _local_4_.gen_ai_spec
  return setup({mappings = {around = "a", inside = "i", around_next = "an", inside_next = "in", around_last = "al", inside_last = "il", goto_left = "[", goto_right = "]"}, custom_textobjects = {F = gen_spec.treesitter({a = "@function.outer", i = "@function.inner"}), c = gen_spec.treesitter({a = "@class.outer", i = "@class.inner"}), o = gen_spec.treesitter({a = {"@conditional.outer", "@loop.outer"}, i = {"@conditional.inner", "@loop.inner"}}), B = gen_ai_spec.buffer(), D = gen_ai_spec.diagnostic(), I = gen_ai_spec.indent(), L = gen_ai_spec.line(), N = gen_ai_spec.number()}})
end
local function _5_()
  return vim.cmd.colorscheme("minisummer")
end
local function _6_()
  return MiniFiles.open()
end
local function _7_()
  return MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
end
return {{"nvim-mini/mini.icons", config = _1_, lazy = false}, {"nvim-mini/mini.cursorword", opts = {}, lazy = false}, {"nvim-mini/mini.move", opts = {}, lazy = false}, {"nvim-mini/mini.ai", dependencies = {{"nvim-mini/mini.extra", opts = {}}}, config = _2_, lazy = false}, {"nvim-mini/mini.surround", opts = {mappings = {add = "ss"}}, lazy = false}, {"nvim-mini/mini.hipatterns", opts = {highlighters = {fixme = {pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme"}, hack = {pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack"}, todo = {pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo"}, note = {pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote"}, warn = {pattern = "%f[%w]()WARNI?N?G?()%f[%W]", group = "MiniHipatternsHack"}, error = {pattern = "%f[%w]()ERRO?R?()%f[%W]", group = "MiniHipatternsFixme"}}}, lazy = false}, {"nvim-mini/mini.hues", init = _5_, enabled = false, lazy = false}, {"nvim-mini/mini.files", opts = {windows = {preview = true}}, keys = {{"<M-1>", _6_, desc = "[mini.files] Open"}, {"<M-2>", _7_, desc = "[mini.files] Open current directory"}}, lazy = false}}
