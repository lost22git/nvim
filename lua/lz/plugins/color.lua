-- [nfnl] fnl/lz/plugins/color.fnl
local function _1_()
  local function _3_()
    local _2_ = vim.o.background
    if (_2_ == "dark") then
      return "PaperColorSlim"
    elseif (_2_ == "light") then
      return "PaperColorSlimLight"
    else
      return nil
    end
  end
  return vim.cmd.colorscheme(_3_())
end
return {{"NvChad/nvim-colorizer.lua", cmd = "ColorizerAttachToBuffer", opts = {user_default_options = {tailwind = true, mode = "virtualtext", virtualtext_inline = "before"}}}, {"nickkadutskyi/jb.nvim", priority = 1000, opts = {disable_hl_args = {italic = true, bold = false}}, lazy = false}, {"oneslash/helix-nvim", priority = 1000, lazy = false}, {"whizikxd/naysayer-colors.nvim", priority = 1000, lazy = false}, {"EdenEast/nightfox.nvim", priority = 1000, opts = {groups = {all = {MiniCursorWord = {link = "Underlined"}, MiniCursorWordCurrent = {link = "Underlined"}}}}, lazy = false}, {"pappasam/papercolor-theme-slim", priority = 1000, init = _1_, lazy = false}, {"RRethy/base16-nvim", priority = 1000, lazy = false}}
