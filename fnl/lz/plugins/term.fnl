{1 "numToStr/FTerm.nvim"
 :keys [{1 "<M-3>"
         2 "<C-\\><C-n><Cmd>lua require(\"FTerm\").toggle()<CR>"
         :mode [:n :v :i :t]
         :noremap true
         :desc "[FTerm] Toggle"}]
 :opts {:ft "FTerm"
        :cmd (or vim.g.zz.shell vim.o.shell)
        :border vim.o.winborder}}
