(import-macros {: autocmd! : bufusercmd! : nmap! : vmap! : nvmap! : call!}
               :config.macros)

[{1 "Olical/conjure"
  :cmd :ConjureConnect
  :event :VeryLazy
  :init (fn []
          (set vim.g.conjure#highlight#enabled true)
          (set vim.g.conjure#extract#tree_sitter#enabled true)
          (set vim.g.conjure#log#jump_to_latest#enabled true)
          (set vim.g.conjure#mapping#doc_word [:<LocalLeader>k])
          (set vim.g.conjure#mapping#eval_visual [:<LocalLeader>ee])
          (set vim.g.conjure#mapping#eval_previous [:<LocalLeader>E])

          (fn configure-chez-scheme []
            (set vim.g.conjure#client#scheme#stdio#command "petite")
            (set vim.g.conjure#client#scheme#stdio#prompt_pattern "> $?"))

          (fn configure-chicken-scheme []
            (set vim.g.conjure#client#scheme#stdio#command "chicken-csi -:c")
            (set vim.g.conjure#client#scheme#stdio#prompt_pattern "\n-#;%d-> ")
            (set vim.g.conjure#client#scheme#stdio#value_prefix_pattern false))

          (fn change-scheme [lang]
            (vim.cmd :ConjureSchemeStop)
            (case lang
              :chez (configure-chez-scheme)
              :chicken (configure-chicken-scheme))
            (vim.cmd :ConjureSchemeStart))

          ;; For the first time, configure ChezScheme repl for Scheme
          (configure-chez-scheme)
          (autocmd! :FileType
                    {:desc "create `ConjureSchemeChange` usercmd to change conjure repl for Scheme"
                     :pattern :scheme
                     :callback #(bufusercmd! $.buf :ConjureSchemeChange
                                             (fn [{:fargs [lang]}]
                                               (change-scheme lang))
                                             {:nargs 1
                                              :complete (fn []
                                                          [:chez :chicken])})})
          (autocmd! :BufWinEnter
                    {:desc "create keymaps for conjure log"
                     :pattern ["conjure-log-*"]
                     :callback (fn [{:buf bufid}]
                                 (local {: disable_diagnostic
                                         : create_keymaps_for_goto_entry}
                                        (require :core.utils))
                                 (disable_diagnostic)
                                 (create_keymaps_for_goto_entry "\\v^(;|--|#|\\/\\/) -+$"
                                                                "[e" "]e"
                                                                :conjure_log
                                                                bufid))}))}
 {1 "pappasam/nvim-repl"
  :cmd :Repl
  :opts {:filetype_commands {:arturo {:cmd "arturo --repl"}
                             :basilisp {:cmd "basilisp repl"}
                             :crystal {:cmd "crystal i"}
                             :elixir {:cmd "iex"}
                             :flix {:cmd "flix repl"}
                             :haskell {:cmd "ghci"}
                             :java {:cmd "jshell"}
                             :kotlin {:cmd "rlwrap kotlin -repl"}
                             :lfe {:cmd "lfe"}
                             :nim {:cmd "inim"}
                             :racket {:cmd "rlwrap racket -i"}
                             :raku {:cmd "rlwrap raku"}
                             :roc {:cmd "roc repl"}
                             :lisp {:cmd "rlwrap sbcl"}
                             :swift {:cmd "swift repl"}
                             :typescript {:cmd "deno repl"}
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
