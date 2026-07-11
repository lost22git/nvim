(import-macros {: fn!} :config.macros)

[{1 "lewis6991/gitsigns.nvim"
  :event :VeryLazy
  :opts {:numhl true :on_attach (fn! :core.maps :gitsigns)}}]
