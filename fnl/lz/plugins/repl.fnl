(import-macros {: autocmd : nmap : vmap : nvmap} :config.macros)
[{1 "Olical/conjure"
  :cmd :ConjureConnect
  :ft [:lua :fennel :clojure :janet :racket]
  :init (fn []
          (set vim.g.conjure#highlight#enabled true)
          (set vim.g.conjure#extract#tree_sitter#enabled true)
          (set vim.g.conjure#log#jump_to_latest#enabled true)
          (set vim.g.conjure#mapping#doc_word [:<LocalLeader>k])
          (set vim.g.conjure#mapping#eval_visual [:<LocalLeader>ee])
          (set vim.g.conjure#mapping#eval_replace_form [:<LocalLeader>es])
          (set vim.g.conjure#mapping#eval_previous [:<LocalLeader>E])
          (autocmd :BufWinEnter
                   {:pattern ["conjure-log-*"]
                    :callback (fn [ev]
                                (local bufid ev.buf)
                                (local {: disable_diagnostic}
                                       (require :core.utils))
                                (local p "\\v^(;|--|#) -+$")
                                (nvmap "[e"
                                       (string.format "<Cmd>call search(\"%s\" \"bw\")<CR>"
                                                      p)
                                       {:buffer bufid
                                        :desc "[conjure] Goto prev log"})
                                (nvmap "]e"
                                       (string.format "<Cmd>call search(\"%s\" \"w\")<CR>"
                                                      p)
                                       {:buffer bufid
                                        :desc "[conjure] Goto next log"}))}))}
 {1 "pappasam/nvim-repl"
  :cmd :Repl
  :opts {:filetype_commands {:crystal {:cmd "crystal i"}
                             :elixir {:cmd "iex"}
                             :java {:cmd "jshell"}
                             :lfe {:cmd "lfe"}
                             :nim {:cmd "inim"}
                             :raku {:cmd "rlwrap raku"}
                             :swift {:cmd "swift repl"}}}
  :config (fn [_ opts]
            ((. (require :repl) :setup) opts)
            (local ftypes (vim.tbl_keys opts.filetype_commands))

            (fn create_keymaps [bufid]
              (nmap :<Leader>ee "<Plug>(ReplSendLine)"
                    {:buffer bufid :desc "[repl] SendLine"})
              (vmap :<Leader>ee "<Plug>(ReplSendVisual)"
                    {:buffer bufid :desc "[repl] SendVisual"}))

            (autocmd :FileType
                     {:pattern ftypes :callback #(create_keymaps $1.buf)})
            (when (vim.tbl_contains ftypes vim.bo.filetype)
              (create_keymaps 0)))}]
