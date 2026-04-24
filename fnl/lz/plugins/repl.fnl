(import-macros {: on! : bufusercmd! : nmap! : vmap! : nvmap! : call!}
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
            (set vim.g.conjure#client#scheme#stdio#prompt_pattern "> $?")
            (set vim.g.conjure#client#scheme#stdio#value_prefix_pattern false))

          (fn configure-chicken-scheme []
            (set vim.g.conjure#client#scheme#stdio#command
                 "chicken-csi -:c -R apropos")
            (set vim.g.conjure#client#scheme#stdio#prompt_pattern "\n-#;%d-> ")
            (set vim.g.conjure#client#scheme#stdio#value_prefix_pattern false))

          (fn configure-nodejs []
            (set vim.g.conjure#client#javascript#stdio#typescript_cmd "ts-node")
            (set vim.g.conjure#client#javascript#stdio#javascript_cmd
                 "node --experimental-repl-await")
            (set vim.g.conjure#client#javascript#stdio#args "-i"))

          (fn configure-deno []
            (set vim.g.conjure#client#javascript#stdio#typescript_cmd "deno")
            (set vim.g.conjure#client#javascript#stdio#javascript_cmd "deno")
            (set vim.g.conjure#client#javascript#stdio#args "repl"))

          (fn conjure-change [ft repl]
            (case ft
              :scheme (vim.cmd :ConjureSchemeStop)
              (where (or :javascript :typescript)) (vim.cmd :ConjureJavascriptStop))
            (case [ft repl]
              [:scheme :chez] (configure-chez-scheme)
              [:scheme :chicken] (configure-chicken-scheme)
              [:javascript :nodejs] (configure-nodejs)
              [:javascript :deno] (configure-deno)
              [:typescript :nodejs] (configure-nodejs)
              [:typescript :deno] (configure-deno))
            (case ft
              :scheme (vim.cmd :ConjureSchemeStart)
              (where (or :javascript :typescript)) (vim.cmd :ConjureJavascriptStart)))

          (fn conjure-change-arg-cmp [ft]
            (case ft
              :scheme [:chez :chicken]
              :javascript [:nodejs :deno]
              :typescript [:nodejs :deno]))

          (configure-chicken-scheme)
          (configure-nodejs)
          (on! :FileType
               {:desc "create `ConjureChange` usercmd to change REPL"
                :pattern [:scheme :javascript :typescript]
                :callback (fn [{: buf}]
                            (var ft (. vim.bo buf :filetype))
                            (bufusercmd! buf :ConjureChange
                                         (fn [{:fargs [repl]}]
                                           (conjure-change ft repl))
                                         {:nargs 1
                                          :complete #(conjure-change-arg-cmp ft)}))})
          (on! :BufWinEnter
               {:desc "create keymaps for conjure log"
                :pattern ["conjure-log-*"]
                :callback (fn [{:buf bufid}]
                            (local {: disable_diagnostic
                                    : create_keymaps_for_goto_entry}
                                   (require :core.utils))
                            (disable_diagnostic)
                            (create_keymaps_for_goto_entry "\\v^(;|--|#|\\/\\/) -+$"
                                                           "[e" "]e"
                                                           :conjure_log bufid))}))}
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
                             :ocaml {:cmd "rlwrap ocaml"}
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

            (on! :FileType {:pattern ftypes :callback #(create_keymaps $.buf)})
            (when (vim.list_contains ftypes vim.bo.filetype)
              (create_keymaps 0)))}]
