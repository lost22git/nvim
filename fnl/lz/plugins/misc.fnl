(import-macros {: nmap : autocmd} :config.macros)

[{1 "lukas-reineke/indent-blankline.nvim"
  :main :ibl
  :opts {:indent {:char "▏"}}
  :keys [{1 "<Leader>i"
          2 "<Cmd>IBLToggle<CR>"
          :mode [:n :v]
          :desc "[IBL] Toggle"}]}
 {1 "nvim-focus/focus.nvim"
  :cmd :FocusEnable
  :opts {:ui {:cursorline false :signcolumn false}}}
 {1 "lost22git/true-zen.nvim"
  :branch "fix-by-lost"
  :opts {}
  :keys [{1 "<Leader>za" 2 "<Cmd>TZAtaraxis<CR>" :desc "[true-zen] TZAtaraxis"}
         {1 "<Leader>zf" 2 "<Cmd>TZFocus<CR>" :desc "[true-zen] TZFocus"}
         {1 "<Leader>zm"
          2 "<Cmd>TZMinimalist<CR>"
          :desc "[true-zen] TZMinimalist"}
         {1 "<Leader>zn" 2 "<Cmd>TZNarrow<CR>" :desc "[true-zen] TZNarrow"}]}
 {1 "s1n7ax/nvim-window-picker"
  :opts {:hint "floating-big-letter" :filter_rules {:bo {:buftype {}}}}
  :keys [{1 "<Leader>w"
          2 #(vim.api.nvim_set_current_win ((. (require :window-picker)
                                               :pick_window)))
          :mode [:n :v]
          :desc "[window-picker] Pick window"}]}
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
 {1 "aaronik/treewalker.nvim"
  :opts {:highlight true :highlight_duration 300 :highlight_group :Visual}
  :keys (let [data [[:th :Left]
                    [:tl :Right]
                    [:tk :Up]
                    [:tj :Down]
                    [:tsh :SwapLeft]
                    [:tsl :SwapRight]
                    [:tsk :SwapUp]
                    [:tsj :SwapDown]]]
          (icollect [_ [k v] (ipairs data)]
            {1 k
             2 (.. "<Cmd>Treewalker " v "<CR>")
             :mode (if (vim.startswith v :Swap) :n [:n :v])
             :desc (.. "[treewalker] " v)}))}
 {1 "nvimdev/modeline.nvim" :lazy false :opts {}}
 {1 "mikavilpas/yazi.nvim" :opts {}}]
