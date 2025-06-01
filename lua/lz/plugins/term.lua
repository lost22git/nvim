-- [nfnl] fnl/lz/plugins/term.fnl
return {"numToStr/FTerm.nvim", keys = {{"<M-3>", "<C-\\><C-n><Cmd>lua require(\"FTerm\").toggle()<CR>", mode = {"n", "v", "i", "t"}, noremap = true, desc = "[FTerm] Toggle"}}, opts = {ft = "FTerm", cmd = (vim.g.zz.shell or vim.o.shell), border = vim.o.winborder}}
