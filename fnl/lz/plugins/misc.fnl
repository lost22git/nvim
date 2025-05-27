(import-macros {: nmap! : autocmd!} :config.macros)

[{1 "lukas-reineke/indent-blankline.nvim"
  :main :ibl
  :opts {:indent {:char "▏"}}
  :keys [{1 "<Leader>i"
          2 "<Cmd>IBLToggle<CR>"
          :mode [:n :v]
          :desc "[IBL] Toggle"}]}
 {1 "stevearc/quicker.nvim"
  :ft :qf
  :keys [{1 "<Leader>q"
          2 #((. (require :quicker) :toggle))
          :desc "[quicker] Toggle qflist"}
         {1 "<Leader>l"
          2 #((. (require :quicker) :toggle) {:loclist true})
          :desc "[quicker] Toggle loclist"}]
  :opts {:keys [{1 ">"
                 2 #((. (require :quicker) :expand) {:before 2
                                                     :after 2
                                                     :add_to_existing true})
                 :desc "[quicker] Expand context"}
                {1 "<"
                 2 #((. (require :quicker) :collapse))
                 :desc "[quicker] Collapse context"}]}}
 {1 "numToStr/FTerm.nvim"
  :keys [{1 "<M-3>"
          2 "<C-\\><C-n><Cmd>lua require(\"FTerm\").toggle()<CR>"
          :mode [:n :v :i :t]
          :noremap true
          :desc "[FTerm] Toggle"}]
  :opts {:ft "FTerm"
         :cmd (or vim.g.zz.shell vim.o.shell)
         :border vim.o.winborder}}
 {1 "EL-MASTOR/bufferlist.nvim"
  :keys [{1 "<Leader>b" 2 "<Cmd>BufferList<CR>" :desc "[bufferlist] Open"}]
  :opts {}}
 {1 "mbbill/undotree"
  :keys [{1 :<Leader>u 2 "<CMD>UndotreeToggle<CR>" :desc "[undotree] Toggle"}]}
 {1 "MagicDuck/grug-far.nvim" :cmd [:GrugFar :GrugFarWithin] :opts {}}
 {1 "mikavilpas/yazi.nvim" :cmd :Yazi :opts {}}]
