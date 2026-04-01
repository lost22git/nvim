-- [nfnl] fnl/lz/plugins/git.fnl
local function _1_()
  return require("neogit").setup({highlight = {italic = false}})
end
return {{"lewis6991/gitsigns.nvim", event = "VeryLazy", opts = {numhl = true, on_attach = require("core.maps").gitsigns}}, {"NeogitOrg/neogit", dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim"}, cmd = {"Neogit", "NeogitCommit"}, config = _1_}}
