(import-macros {: fn!} :config.macros)

[{1 "tpope/vim-fugitive" :cmd :Git}
 {1 "lewis6991/gitsigns.nvim"
  :event :VeryLazy
  :opts {:numhl true :on_attach #((fn! :core.maps :gitsigns) $)}}
 {1 "NeogitOrg/neogit"
  :dependencies ["nvim-lua/plenary.nvim" "sindrets/diffview.nvim"]
  :cmd [:Neogit :NeogitCommit]
  :config (fn []
            (local {: setup} (require :neogit))
            (setup {:highlight {:italic false}}))}]
