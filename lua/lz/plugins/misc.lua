-- [nfnl] fnl/lz/plugins/misc.fnl
local function _1_()
  return require("quicker").toggle()
end
local function _2_()
  return require("quicker").toggle({loclist = true})
end
local function _3_()
  return require("quicker").expand({before = 2, after = 2, add_to_existing = true})
end
local function _4_()
  return require("quicker").collapse()
end
return {{"lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {indent = {char = "\226\150\143"}}, keys = {{"<Leader>i", "<Cmd>IBLToggle<CR>", mode = {"n", "v"}, desc = "[IBL] Toggle"}}}, {"stevearc/quicker.nvim", ft = "qf", keys = {{"<Leader>q", _1_, desc = "[quicker] Toggle qflist"}, {"<Leader>l", _2_, desc = "[quicker] Toggle loclist"}}, opts = {keys = {{">", _3_, desc = "[quicker] Expand context"}, {"<", _4_, desc = "[quicker] Collapse context"}}}}, {"numToStr/FTerm.nvim", keys = {{"<M-3>", "<C-\\><C-n><Cmd>lua require(\"FTerm\").toggle()<CR>", mode = {"n", "v", "i", "t"}, noremap = true, desc = "[FTerm] Toggle"}}, opts = {ft = "FTerm", cmd = (vim.g.zz.shell or vim.o.shell), border = vim.o.winborder}}, {"EL-MASTOR/bufferlist.nvim", keys = {{"<Leader>b", "<Cmd>BufferList<CR>", desc = "[bufferlist] Open"}}, opts = {}}, {"mbbill/undotree", keys = {{"<Leader>u", "<CMD>UndotreeToggle<CR>", desc = "[undotree] Toggle"}}}, {"MagicDuck/grug-far.nvim", cmd = {"GrugFar", "GrugFarWithin"}, opts = {}}, {"mikavilpas/yazi.nvim", cmd = "Yazi", opts = {}}}
