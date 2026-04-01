-- [nfnl] fnl/lz/plugins/x_markdown.fnl
local function _1_()
  require("render-markdown").setup({})
  return vim.keymap.set("n", "<Tab>p", "<CMD>RenderMarkdown toggle<CR>")
end
return {"MeanderingProgrammer/render-markdown.nvim", ft = "markdown", config = _1_}
