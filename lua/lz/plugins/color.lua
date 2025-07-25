-- [nfnl] fnl/lz/plugins/color.fnl
local function _1_()
  local function _3_()
    local _2_ = vim.o.background
    if (_2_ == "dark") then
      return "base16-da-one-black"
    elseif (_2_ == "light") then
      return "base16-cupertino"
    else
      return nil
    end
  end
  return vim.cmd.colorscheme(_3_())
end
return {{"NvChad/nvim-colorizer.lua", cmd = "ColorizerAttachToBuffer", opts = {user_default_options = {tailwind = true, mode = "virtualtext", virtualtext_inline = "before"}}}, {"uga-rosa/ccc.nvim", cmd = {"CccPick", "CccCovert", "CccHighlighterToggle"}, opts = {}}, {"nickkadutskyi/jb.nvim", priority = 1000, opts = {disable_hl_args = {italic = true, bold = false}}, enabled = false, lazy = false}, {"oneslash/helix-nvim", priority = 1000, enabled = false, lazy = false}, {"EdenEast/nightfox.nvim", priority = 1000, opts = {groups = {all = {MiniCursorWord = {link = "Underlined"}, MiniCursorWordCurrent = {link = "Underlined"}}}}, enabled = false, lazy = false}, {"pappasam/papercolor-theme-slim", priority = 1000, enabled = false, lazy = false}, {"RRethy/base16-nvim", priority = 1000, init = _1_, lazy = false}}
