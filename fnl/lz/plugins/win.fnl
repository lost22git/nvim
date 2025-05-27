[{1 "nvim-focus/focus.nvim"
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
  :opts {:hint "floating-big-letter"}
  :keys [{1 "<Leader>w"
          2 #(vim.api.nvim_set_current_win ((. (require :window-picker)
                                               :pick_window)))
          :mode [:n :v]
          :desc "[window-picker] Pick window"}]}]
