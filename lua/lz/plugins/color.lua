-- [nfnl] fnl/lz/plugins/color.fnl
local function _1_()
  return vim.cmd.colorscheme("doric-beach")
end
return {{"NvChad/nvim-colorizer.lua", cmd = "ColorizerAttachToBuffer", opts = {user_default_options = {tailwind = true, mode = "virtualtext", virtualtext_inline = "before"}}}, {"uga-rosa/ccc.nvim", cmd = {"CccPick", "CccCovert", "CccHighlighterToggle"}, opts = {}}, {"aymenhafeez/doric-themes.nvim", priority = 1000, init = _1_, opts = {styles = {bold = true, italic = false}}, lazy = false}}
