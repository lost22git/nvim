-- [nfnl] fnl/lz/plugins/color.fnl
local function _1_()
  return vim.cmd.colorscheme("jb")
end
return {{"NvChad/nvim-colorizer.lua", cmd = "ColorizerAttachToBuffer", opts = {user_default_options = {tailwind = true, mode = "virtualtext", virtualtext_inline = "before"}}}, {"uga-rosa/ccc.nvim", cmd = {"CccPick", "CccCovert", "CccHighlighterToggle"}, opts = {}}, {"nickkadutskyi/jb.nvim", priority = 1000, opts = {disable_hl_args = {italic = true, bold = false}}, init = _1_, lazy = false}, {"oneslash/helix-nvim", priority = 1000, lazy = false}, {"whizikxd/naysayer-colors.nvim", priority = 1000, lazy = false}, {"EdenEast/nightfox.nvim", priority = 1000, opts = {groups = {all = {MiniCursorWord = {link = "Underlined"}, MiniCursorWordCurrent = {link = "Underlined"}}}}, lazy = false}, {"pappasam/papercolor-theme-slim", priority = 1000, lazy = false}, {"RRethy/base16-nvim", priority = 1000, lazy = false}}
