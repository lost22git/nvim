(import-macros {: on!} :config.macros)

(on! :Filetype {:desc "[TS] vim.treesitter.start()"
                :callback (fn [{: buf}]
                            (pcall vim.treesitter.start buf)
                            nil)})
