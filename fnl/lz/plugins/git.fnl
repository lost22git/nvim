[{1 "tpope/vim-fugitive" :cmd :Git}
 {1 "lewis6991/gitsigns.nvim"
  :event :VeryLazy
  :opts {:numhl true :on_attach #((. (require :core.maps) :gitsigns) $)}}
 {1 "NeogitOrg/neogit"
  :dependencies ["nvim-lua/plenary.nvim" "sindrets/diffview.nvim"]
  :cmd [:Neogit :NeogitCommit]
  :config (fn []
            (local {: setup} (require :neogit))
            (setup {:highlight {:italic false}})
            (let [groups {:NeogitDiffAdd {:link :DiffAdd}
                          :NeogitDiffAddHighlight {:link :DiffAdd}
                          :NeogitDiffAddCursor {:link :Added}
                          :NeogitDiffDelete {:link :DiffDelete}
                          :NeogitDiffDeleteHighlight {:link :DiffDelete}
                          :NeogitDiffDeleteCursor {:link :Removed}
                          :NeogitDiffDeletions {:link :Removed}
                          :NeogitGraphRed {:link :Removed}
                          :NeogitGraphBoldRed {:link :NeogitGraphRed
                                               :bold true
                                               :cterm {:bold true}}}]
              (each [k v (pairs groups)]
                (vim.api.nvim_set_hl 0 k v))))}]
