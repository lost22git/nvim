(import-macros {: has!} :config.macros)

(local zz_default {:transparent false
                   :shell (when (has! :win32) "pwsh")
                   :backdrop 100})

(set vim.g.zz (vim.tbl_deep_extend "force" zz_default (or vim.g.zz {})))

(set vim.g.mapleader " ")
(set vim.g.maplocalleader " ")

(set vim.g.markdown_fenced_languages ["ts=typescript"])
(set vim.g.markdown_recommended_style 0)
