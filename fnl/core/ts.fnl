(import-macros {: autocmd!} :config.macros)

(autocmd! :Filetype {:desc "[TS] vim.treesitter.start()"
                     :callback (fn [{: buf}]
                                 (pcall vim.treesitter.start buf)
                                 nil)})
