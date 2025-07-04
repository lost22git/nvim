-- [nfnl] fnl/lz/plugins/git.fnl
local function _1_(_241)
  return require("core.maps").gitsigns(_241)
end
local function _2_()
  local _local_3_ = require("neogit")
  local setup = _local_3_["setup"]
  setup({highlight = {italic = false}})
  local groups = {NeogitDiffAdd = {link = "DiffAdd"}, NeogitDiffAddHighlight = {link = "DiffAdd"}, NeogitDiffAddCursor = {link = "Added"}, NeogitDiffDelete = {link = "DiffDelete"}, NeogitDiffDeleteHighlight = {link = "DiffDelete"}, NeogitDiffDeleteCursor = {link = "Removed"}, NeogitDiffDeletions = {link = "Removed"}, NeogitGraphRed = {link = "Removed"}, NeogitGraphBoldRed = {link = "NeogitGraphRed", bold = true, cterm = {bold = true}}}
  for k, v in pairs(groups) do
    vim.api.nvim_set_hl(0, k, v)
  end
  return nil
end
return {{"tpope/vim-fugitive", cmd = "Git"}, {"lewis6991/gitsigns.nvim", event = "VeryLazy", opts = {numhl = true, on_attach = _1_}}, {"NeogitOrg/neogit", dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim"}, cmd = {"Neogit", "NeogitCommit"}, config = _2_}}
