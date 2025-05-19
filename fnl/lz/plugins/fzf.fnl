{1 "ibhagwan/fzf-lua"
 :cmd :FzfLua
 :opts {:fzf_colors true
        :winopts {:backdrop vim.g.zz.backdrop :preview {:hidden true}}}
 :config (fn [_ opts]
           (local fzf (require :fzf-lua))
           (fzf.setup opts)
           (fzf.register_ui_select))
 :keys (let [data [[:f :builtin]
                   [:F :resume]
                   [:f? :helptags]
                   [:f/ :search_history]
                   ["f:" :command_history]
                   [:f<Tab> :tabs]
                   [:fb :buffers]
                   [:fd :lsp_document_diagnostics]
                   [:fD :lsp_workspace_diagnostics]
                   [:fe :oldfiles]
                   [:ff :files]
                   [:fg :lsp_finder]
                   [:fh :git_hunks]
                   [:fi :lsp_implementations]
                   [:fk :keymaps]
                   [:fO :lsp_document_symbols]
                   [:fr :lsp_references]
                   [:fs :live_grep]
                   [:fz :zoxide]]]
         (icollect [_ [k v] (pairs data)]
           {1 (.. :<Leader> k)
            2 (.. "<CMD>FzfLua " v "<CR>")
            :desc (.. "[fzflua] " v)}))}
