-- [nfnl] fnl/lz/plugins/color.fnl
local ft_colors = {clojure = "cyberdream", janet = "cyberdream", java = "jb"}
local function get_ft_color(ft)
  local v = ft_colors[ft]
  local _1_ = type(v)
  if (_1_ == "string") then
    return v
  elseif (_1_ == "table") then
    return v[vim.o.background]
  else
    return nil
  end
end
local function _3_(ev)
  vim.cmd.colorscheme(get_ft_color(ev.match))
  return nil
end
vim.api.nvim_create_autocmd("FileType", {desc = "change colorscheme for filetype", pattern = vim.tbl_keys(ft_colors), nested = true, callback = _3_})
return {{"NvChad/nvim-colorizer.lua", cmd = "ColorizerAttachToBuffer", opts = {user_default_options = {tailwind = true, mode = "virtualtext", virtualtext_inline = "before"}}}, {"uga-rosa/ccc.nvim", cmd = {"CccPick", "CccCovert", "CccHighlighterToggle"}, opts = {}}, {"nickkadutskyi/jb.nvim", priority = 1000, opts = {disable_hl_args = {italic = true, bold = false}}, lazy = false}, {"EdenEast/nightfox.nvim", priority = 1000, opts = {groups = {all = {MiniCursorWord = {link = "Underlined"}, MiniCursorWordCurrent = {link = "Underlined"}}}}, lazy = false}, {"pappasam/papercolor-theme-slim", priority = 1000, lazy = false}, {"scottmckendry/cyberdream.nvim", priority = 1000, lazy = false}}
