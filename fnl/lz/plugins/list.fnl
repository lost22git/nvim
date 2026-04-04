(import-macros {: call! : on!} :config.macros)

[{1 "stevearc/aerial.nvim"
  :opts {}
  :keys [{1 "<Leader>O" 2 "<Cmd>AerialToggle<Cr>" :desc "[aerial] toggle"}]}
 {1 "stevearc/quicker.nvim"
  :ft :qf
  :keys [{1 "<Leader>q"
          2 #(call! :quicker :toggle)
          :desc "[quicker] Toggle qflist"}
         {1 "<Leader>l"
          2 #(call! :quicker :toggle {:loclist true})
          :desc "[quicker] Toggle loclist"}]
  :opts {:keys [{1 ">"
                 2 #(call! :quicker :expand
                           {:before 2 :after 2 :add_to_existing true})
                 :desc "[quicker] Expand context"}
                {1 "<"
                 2 #(call! :quicker :collapse)
                 :desc "[quicker] Collapse context"}]}}
 {1 "mikavilpas/yazi.nvim" :cmd :Yazi :opts {}}
 {1 "ibhagwan/fzf-lua"
  :opts {:fzf_colors true
         :winopts {:backdrop vim.g.zz.backdrop :preview {:hidden true}}}
  :config (fn [_ opts]
            (local {: setup : register_ui_select} (require :fzf-lua))
            (setup opts)
            (register_ui_select))
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
                    [:fF :lsp_finder]
                    [:fg :live_grep]
                    [:fG "live_grep resume=true"]
                    [:fh :git_hunks]
                    [:fi :lsp_implementations]
                    [:fk :keymaps]
                    [:fl :blines]
                    [:fr :lsp_references]
                    [:fs :lsp_document_symbols]
                    [:fz :zoxide]]]
          (icollect [_ [k v] (pairs data)]
            {1 (.. :<Leader> k)
             2 (.. "<CMD>FzfLua " v "<CR>")
             :desc (.. "[fzflua] " v)}))}]
