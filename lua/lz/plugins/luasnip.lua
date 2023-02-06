local friendly_snippets = {
  'rafamadriz/friendly-snippets',
}
function friendly_snippets.config()
  require("luasnip.loaders.from_vscode").lazy_load()
end

local M = {
  'L3MON4D3/LuaSnip',
  dependencies = {
    friendly_snippets,
  },
}
return M
