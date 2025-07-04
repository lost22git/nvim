[{1 "ibhagwan/fzf-lua"
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
                    [:fF :lsp_finder]
                    [:fg :live_grep]
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
             :desc (.. "[fzflua] " v)}))}
 {1 "mbbill/undotree"
  :keys [{1 :<Leader>u 2 "<CMD>UndotreeToggle<CR>" :desc "[undotree] Toggle"}]}
 {1 "stevearc/aerial.nvim"
  :opts {}
  :keys [{1 "<Leader>O" 2 "<Cmd>AerialToggle<Cr>" :desc "[aerial] toggle"}]}
 {1 "stevearc/quicker.nvim"
  :ft :qf
  :keys [{1 "<Leader>q"
          2 #((. (require :quicker) :toggle))
          :desc "[quicker] Toggle qflist"}
         {1 "<Leader>l"
          2 #((. (require :quicker) :toggle) {:loclist true})
          :desc "[quicker] Toggle loclist"}]
  :opts {:keys [{1 ">"
                 2 #((. (require :quicker) :expand) {:before 2
                                                     :after 2
                                                     :add_to_existing true})
                 :desc "[quicker] Expand context"}
                {1 "<"
                 2 #((. (require :quicker) :collapse))
                 :desc "[quicker] Collapse context"}]}}
 {1 "mikavilpas/yazi.nvim" :cmd :Yazi :opts {}}
 {1 "bassamsdata/namu.nvim"
  :cmd :Namu
  :opts {:global {:movement {:next ["<M-j>" "<DOWN>"]
                             :previous ["<M-k>" "<UP>"]
                             :close ["<C-c>" "<Esc>"]}
                  :multiselect {:enabled true
                                :selected_icon "✓"
                                :keymaps {:toggle "<Tab>"
                                          :untoggle "<S-Tab>"
                                          :select_all "<M-a>"
                                          :clear_all "<M-x>"}}
                  :custom_keymaps {:yank {:keys ["<M-y>"]
                                          :desc "Yank symbol text"}
                                   :delete {:keys ["M-d"]
                                            :desc "Delete symbol text"}}}
         :namu_symbols {:enable true :options {}}
         :ui_select {:enable false}}
  :keys (let [data [[:nd :diagnostics]
                    [:nD "diagnostics workspace"]
                    [:ne :watchtower]
                    [:ns :symbols]
                    [:nt :treesitter]
                    [:nw :workspace]]]
          (icollect [_ [k v] (pairs data)]
            {1 (.. :<Leader> k)
             2 (.. "<CMD>Namu " v "<CR>")
             :desc (.. "[namu] " v)}))}]
