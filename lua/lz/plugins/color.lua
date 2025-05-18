-- [nfnl] fnl/lz/plugins/color.fnl
local function _1_()
  return vim.cmd.colorscheme("dayfox")
end
return {{"NvChad/nvim-colorizer.lua", cmd = "ColorizerAttachToBuffer", opts = {user_default_options = {tailwind = true, mode = "virtualtext", virtualtext_inline = "before"}}}, {"nickkadutskyi/jb.nvim", opts = {disable_hl_args = {italic = true, bold = false}, transparent = false}, lazy = false}, {"oneslash/helix-nvim", lazy = false}, {"whizikxd/naysayer-colors.nvim", lazy = false}, {"scottmckendry/cyberdream.nvim", opts = {variant = "light", cache = true, transparent = false}, lazy = false}, {"EdenEast/nightfox.nvim", opts = {groups = {all = {MiniCursorWord = {link = "Underlined"}, MiniCursorWordCurrent = {link = "Underlined"}}}}, init = _1_, lazy = false}, {"pappasam/papercolor-theme-slim", lazy = false}}
