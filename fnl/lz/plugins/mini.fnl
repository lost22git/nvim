(import-macros {: call!} :config.macros)

[{1 "nvim-mini/mini.icons"
  :lazy false
  :config (fn []
            (call! :mini.icons :setup)
            (MiniIcons.mock_nvim_web_devicons))}
 {1 "nvim-mini/mini.cursorword" :lazy false :opts {}}
 {1 "nvim-mini/mini.move" :lazy false :opts {}}
 {1 "nvim-mini/mini.files"
  :lazy false
  :opts {:windows {:preview true}}
  :keys [{1 :<M-1> 2 #(MiniFiles.open) :desc "[mini.files] Open"}
         {1 :<M-2>
          2 #(MiniFiles.open (vim.api.nvim_buf_get_name 0) false)
          :desc "[mini.files] Open current directory"}]}]
