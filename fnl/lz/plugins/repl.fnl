(import-macros {: autocmd! : nmap! : vmap! : nvmap! : call!} :config.macros)
[{1 "Olical/conjure"
  :cmd :ConjureConnect
  :event :VeryLazy
  :init (fn []
          (set vim.g.conjure#highlight#enabled true)
          (set vim.g.conjure#extract#tree_sitter#enabled true)
          (set vim.g.conjure#log#jump_to_latest#enabled true)
          (set vim.g.conjure#mapping#doc_word [:<LocalLeader>k])
          (set vim.g.conjure#mapping#eval_visual [:<LocalLeader>ee])
          (set vim.g.conjure#mapping#eval_replace_form [:<LocalLeader>es])
          (set vim.g.conjure#mapping#eval_previous [:<LocalLeader>E])
          (autocmd! :BufWinEnter
                    {:pattern ["conjure-log-*"]
                     :callback (fn [{:buf bufid}]
                                 (local {: disable_diagnostic
                                         : create_keymaps_for_goto_entry}
                                        (require :core.utils))
                                 (disable_diagnostic)
                                 (create_keymaps_for_goto_entry "\\v^(;|--|#) -+$"
                                                                "[e" "]e"
                                                                :conjure_log
                                                                bufid))}))}
 {1 "pappasam/nvim-repl"
  :cmd :Repl
  :opts {:filetype_commands {:arturo {:cmd "arturo --repl"}
                             :crystal {:cmd "crystal i"}
                             :elixir {:cmd "iex"}
                             :flix {:cmd "flix repl"}
                             :java {:cmd "jshell"}
                             :kotlin {:cmd "kotlin -Xrepl"}
                             :lfe {:cmd "lfe"}
                             :nim {:cmd "inim"}
                             :raku {:cmd "rlwrap raku"}
                             :roc {:cmd "roc repl"}
                             :swift {:cmd "swift repl"}
                             :v {:cmd "v repl"}}}
  :config (fn [_ opts]
            (call! :repl :setup opts)
            (local ftypes (vim.tbl_keys opts.filetype_commands))

            (fn create_keymaps [bufid]
              (nmap! :<Leader>ee "<Plug>(ReplSendLine)"
                     {:buffer bufid :desc "[repl] SendLine"})
              (vmap! :<Leader>ee "<Plug>(ReplSendVisual)"
                     {:buffer bufid :desc "[repl] SendVisual"}))

            (autocmd! :FileType
                      {:pattern ftypes :callback #(create_keymaps $.buf)})
            (when (vim.list_contains ftypes vim.bo.filetype)
              (create_keymaps 0)))}]
