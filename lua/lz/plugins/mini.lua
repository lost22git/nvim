-- [nfnl] fnl/lz/plugins/mini.fnl
local function _1_()
  require("mini.icons").setup()
  return MiniIcons.mock_nvim_web_devicons()
end
local function _2_()
  return MiniFiles.open()
end
local function _3_()
  return MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
end
local function _4_()
  local _local_5_ = require("mini.ai")
  local setup = _local_5_["setup"]
  local gen_spec = _local_5_["gen_spec"]
  local _local_6_ = require("mini.extra")
  local gen_ai_spec = _local_6_["gen_ai_spec"]
  return setup({mappings = {around = "a", inside = "i", around_next = "an", inside_next = "in", around_last = "al", inside_last = "il", goto_left = "[", goto_right = "]"}, custom_textobjects = {F = gen_spec.treesitter({a = "@function.outer", i = "@function.inner"}), c = gen_spec.treesitter({a = "@class.outer", i = "@class.inner"}), o = gen_spec.treesitter({a = {"@conditional.outer", "@loop.outer"}, i = {"@conditional.inner", "@loop.inner"}}), B = gen_ai_spec.buffer(), D = gen_ai_spec.diagnostic(), I = gen_ai_spec.indent(), L = gen_ai_spec.line(), N = gen_ai_spec.number()}})
end
return {{"echasnovski/mini.icons", config = _1_, lazy = false}, {"echasnovski/mini.cursorword", opts = {}, lazy = false}, {"echasnovski/mini.files", opts = {windows = {preview = true}}, keys = {{"<M-1>", _2_, desc = "[mini.files] Open"}, {"<M-2>", _3_, desc = "[mini.files] Open current directory"}}, lazy = false}, {"echasnovski/mini.move", opts = {}, lazy = false}, {"echasnovski/mini.ai", dependencies = {{"echasnovski/mini.extra", opts = {}}}, config = _4_, lazy = false}, {"echasnovski/mini.surround", opts = {mappings = {add = "ms", delete = "md", find = "mf", find_left = "mF", highlight = "mh", replace = "mr", update_n_lines = "mn", suffix_last = "l", suffix_next = "n"}}, lazy = false}, {"echasnovski/mini.hipatterns", opts = {highlighters = {fixme = {pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme"}, hack = {pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack"}, todo = {pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo"}, note = {pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote"}, warn = {pattern = "%f[%w]()WARNI?N?G?()%f[%W]", group = "MiniHipatternsHack"}, error = {pattern = "%f[%w]()ERRO?R?()%f[%W]", group = "MiniHipatternsFixme"}}}, lazy = false}}
