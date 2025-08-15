-- [nfnl] fnl/lz/plugins/color.fnl
local function _1_()
  return vim.cmd.colorscheme("fleet")
end
local function _2_()
  local _3_ = vim.o.background
  if (_3_ == "light") then
    return vim.cmd.colorscheme("base16-cupertino")
  else
    return nil
  end
end
return {{"NvChad/nvim-colorizer.lua", cmd = "ColorizerAttachToBuffer", opts = {user_default_options = {tailwind = true, mode = "virtualtext", virtualtext_inline = "before"}}}, {"uga-rosa/ccc.nvim", cmd = {"CccPick", "CccCovert", "CccHighlighterToggle"}, opts = {}}, {"nickkadutskyi/jb.nvim", priority = 1000, opts = {disable_hl_args = {italic = true, bold = false}}, lazy = false}, {"razcoen/fleet.nvim", priority = 1000, init = _1_, lazy = false}, {"oneslash/helix-nvim", priority = 1000, lazy = false}, {"EdenEast/nightfox.nvim", priority = 1000, opts = {groups = {all = {MiniCursorWord = {link = "Underlined"}, MiniCursorWordCurrent = {link = "Underlined"}}}}, lazy = false}, {"pappasam/papercolor-theme-slim", priority = 1000, lazy = false}, {"RRethy/base16-nvim", priority = 1000, init = _2_, lazy = false}, {"emanuel2718/vanta.nvim", priority = 1000, opts = {italic = {comments = false, emphasis = false, folds = false, operators = false, strings = false}}, lazy = false}, {"olivercederborg/poimandres.nvim", priority = 1000, lazy = false}, {"ptdewey/monalisa-nvim", priority = 1000, lazy = false}, {"ptdewey/darkearth-nvim", priority = 1000, lazy = false}}
