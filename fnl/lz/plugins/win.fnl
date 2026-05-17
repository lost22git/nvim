(import-macros {: call!} :config.macros)

[{1 "s1n7ax/nvim-window-picker"
  :opts {:hint "floating-big-letter"}
  :keys [{1 "<Leader>w"
          2 #(vim.api.nvim_set_current_win (call! :window-picker :pick_window))
          :mode [:n :v]
          :desc "[window-picker] Pick window"}]}]
