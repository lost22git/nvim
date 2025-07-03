(import-macros {: has! : autocmd! : bufusercmd! : nvmap! : nvomap!}
               :config.macros)

(local {: create_keymaps_for_goto_entry
        : on_v_modes
        : get_current_selection_text
        : open_hover_window} (require :core.utils))

(autocmd! :FileType
          {:desc "Set fileformat to unix"
           :pattern "*"
           :callback #(when (and vim.bo.modifiable
                                 (not (vim.tbl_contains [:qf :FTerm]
                                                        vim.bo.filetype)))
                        (set vim.bo.fileformat :unix))})

(autocmd! :TextYankPost
          {:desc "Highlight yanked text"
           :pattern "*"
           :callback #(vim.hl.on_yank {:higroup :Visual :timeout 200})})

(autocmd! :BufWritePre
          {:desc "Remove trailing whitespace"
           :callback #(vim.cmd "%s/\\s\\+$//e")})

(autocmd! :BufReadPost
          {:desc "Restore cursor position"
           :callback #(vim.cmd "silent! normal! g`\"zv")})

(autocmd! :FileType
          {:desc "Do not list quickfix buffers"
           :pattern :qf
           :callback #(set vim.opt_local.buflisted false)})

(autocmd! :BufWinEnter
          {:desc "Add keymaps for Goto prev/next region"
           :callback #(create_keymaps_for_goto_entry "[-\\/;#] === .\\+ ===$"
                                                     "[r" "]r" :code_region
                                                     $.buf)})

;; === GUI CURSOR STYLE ===

(var GUI_CURSOR_CACHE nil)

(autocmd! [:VimLeave :VimSuspend]
          {:desc "Restore terminal cursor style"
           :pattern "*"
           :callback (fn []
                       (set GUI_CURSOR_CACHE (vim.opt.guicursor:get))
                       (set vim.opt.guicursor {})
                       ;; \x1b[?12l -> disable cursor blink
                       ;; \x1b[6 q -> set cursor style to bar
                       (vim.fn.chansend vim.v.stderr "\x1b[6 q \x1b[?12l")
                       nil)})

(autocmd! :VimResume
          {:desc "Restore nvim cursor style"
           :pattern "*"
           :callback #(when GUI_CURSOR_CACHE
                        (set vim.opt.guicursor GUI_CURSOR_CACHE))})

;; === TMUX ===

(when (?. vim.env :TMUX)
  (autocmd! :BufWritePost {:desc "Reload tmux config after [.tmux.conf] saved"
                           :pattern ".tmux.conf"
                           :callback #(let [cmd (.. "tmux source-file "
                                                    (vim.api.nvim_buf_get_name $.buf))]
                                        (vim.fn.system cmd)
                                        nil)}))

;; === JUST ===

(autocmd! :FileType
          {:desc "[Just] add keymaps for Goto prev/next task"
           :pattern :just
           :callback #(create_keymaps_for_goto_entry "\\v^\\w+.*:$" "[e" "]e"
                                                     :just_task $.buf)})

;; === HTTP ===

(autocmd! :FileType
          {:desc "[Http] add keymaps for Goto prev/next http request"
           :pattern [:http :rest :hurl]
           :callback #(create_keymaps_for_goto_entry "\\v^<(HEAD|GET|POST|PUT|PATCH|DELETE|OPTION)>"
                                                     "[e" "]e" :http_request
                                                     $.buf)})

;; === CLOJURE ===

(autocmd! :FileType
          {:desc "[Clojure] add keymaps for Goto prev/next (comment)"
           :pattern [:clojure :janet]
           :callback #(create_keymaps_for_goto_entry "\\v(^\\(comment|^#_)"
                                                     "[C" "]C" :comment_form
                                                     $.buf)})

(autocmd! :FileType {:desc "[Clojure] add `Clj` usercommand for starting Clojure nREPL server"
                     :pattern :clojure
                     :callback #(bufusercmd! 0 :Clj
                                             (fn [{: args}]
                                               (local clj_opts
                                                      (if (string.match args
                                                                        "%-M:")
                                                          args
                                                          (.. args " " "-M")))
                                               (local deps
                                                      "'{:deps {nrepl/nrepl {:mvn/version \"1.3.0\"} refactor-nrepl/refactor-nrepl {:mvn/version \"3.10.0\"} cider/cider-nrepl {:mvn/version \"0.52.0\"} }}'")
                                               (local cider_opts
                                                      "\"(require 'nrepl.cmdline) (nrepl.cmdline/-main \\\"--interactive\\\" \\\"--middleware\\\" \\\"[refactor-nrepl.middleware/wrap-refactor cider.nrepl/cider-middleware]\\\")\"")
                                               (local command
                                                      (string.format "clj -Sdeps %s %s -e %s"
                                                                     deps
                                                                     clj_opts
                                                                     cider_opts))
                                               (vim.cmd (.. "tabnew | term "
                                                            command)))
                                             {:nargs "*"})})

(autocmd! :FileType {:desc "[Janet] add `JanetNetrepl` usercommand for starting janet-netrepl server"
                     :pattern :janet
                     :callback #(bufusercmd! $.buf :JanetNetrepl
                                             #(vim.cmd (.. "tabnew | term "
                                                           "janet-netrepl"))
                                             {:nargs "*"})})

;; === NVIM HELP ===

(fn nvim_help []
  (local q (if (on_v_modes) (get_current_selection_text)
               (vim.fn.expand "<cword>")))
  (vim.cmd (.. "help " q)))

(autocmd! :FileType {:desc "Add keymaps for nvim help"
                     :pattern [:lua :fennel]
                     :callback (fn [{:buf bufid}]
                                 (fn cb []
                                   (when (= 1 (vim.fn.bufexists bufid))
                                     (nvmap! "<Leader>K" nvim_help
                                             {:buffer bufid
                                              :desc "[base] Nvim help"})))

                                 (vim.defer_fn cb 1000))})

;; TODO
;; compose fns
;; (compose (execute_cmd (if ok
;;            (compose open_hover_window process_content)
;;            (print_error)))
;;          make_cmd
;;          get_text)

;; === CRYSTAL ===

(var add_keymaps_for_docr nil)
(fn docr [subcmd]
  (fn make_cmd [q]
    ["docr" subcmd (.. "'" (vim.fn.escape q "'") "'")])

  (fn process_content [content]
    (-> content
        (string.gsub "\027%[.-m" "")
        (case (a _) a)
        (vim.fn.trim)))

  (fn open_doc_window [content title]
    (local text (process_content content))
    (open_hover_window text title
                       (fn [bufid _winid]
                         (tset vim.bo bufid :filetype :markdown)
                         (add_keymaps_for_docr bufid))))

  (local q (if (on_v_modes) (get_current_selection_text)
               (vim.fn.expand "<cword>")))
  (local cmd (make_cmd q))
  (local cmd_str (table.concat cmd " "))
  (print cmd_str " ...")
  (vim.system cmd {:text true}
              (fn [res]
                (print "")
                (if (or (not= 0 res.code) (not res.stdout) (= "" res.stdout))
                    (vim.print cmd_str res)
                    ((vim.schedule_wrap open_doc_window) res.stdout cmd_str)))))

(set add_keymaps_for_docr
     (fn [bufid]
       (nvmap! "<Leader>k" (partial docr :info)
               {:buffer bufid :desc "[base] docr info"})
       (nvmap! "<Leader>K" (partial docr :search)
               {:buffer bufid :desc "[base] docr search"})
       (nvmap! "<Leader>kk" (partial docr :tree)
               {:buffer bufid :desc "[base] docr tree"})))

(autocmd! :FileType
          {:desc "[Crystal] add keymaps for docr"
           :pattern :crystal
           :callback #(add_keymaps_for_docr $.buf)})

;; === ARTURO ===

(fn arturo_doc [_subcmd]
  (fn make_cmd [q]
    ["sh" "-c" (.. "echo \"info '" q "\" | arturo --no-color")])

  (fn process_content [content]
    (-> content
        (string.match "(%$%>.+)%s*%$%>")
        (string.gsub "\027%[.-m" "")
        (case (a _) a)
        (vim.fn.trim)))

  (fn open_doc_window [content title]
    (local text (process_content content))
    (open_hover_window text title))

  (local q (if (on_v_modes) (get_current_selection_text)
               (vim.fn.expand "<cword>")))
  (local cmd (make_cmd q))
  (local cmd_str (table.concat cmd " "))
  (print cmd_str " ...")
  (vim.system cmd {:text true}
              (fn [res]
                (print "")
                (if (or (not= 0 res.code) (not res.stdout) (= "" res.stdout))
                    (vim.print cmd_str res)
                    ((vim.schedule_wrap open_doc_window) res.stdout cmd_str)))))

(fn add_keymaps_for_arturo_doc [bufid]
  (nvmap! "<Leader>k" (partial arturo_doc :info)
          {:buffer bufid :desc "[base] arturo info"}))

(autocmd! :FileType
          {:desc "[Arturo] add keymaps for arturo doc"
           :pattern :arturo
           :callback #(add_keymaps_for_arturo_doc $.buf)})

;; === LFE ===

(fn lfe_doc [m_or_h]
  (fn make_cmd [q]
    (local qq (case m_or_h
                ;; (m 'proc_ib)
                :m
                (.. "(m '" q ")")
                ;; q='proc_lib' => qq="(h 'proc_lib)"
                ;; q='proc_lib:stop' => qq="(h 'proc_lib 'stop)"
                ;; q='proc_lib:stop/3' => qq="(h 'proc_lib 'stop 3)"
                :h
                (do
                  (local [m fa] (vim.split q ":"))
                  (local [f a] (if fa (vim.split fa "/") []))
                  (.. "(h" ;;
                      (if m (.. " '" m) "") ;; mode
                      (if f (.. " '" f) "") ;; func
                      (if a (.. " " a) "") ;; arity
                      ")"))))
    ["lfe" "-e" qq])

  (fn process_content [content]
    (-> content
        (string.gsub "\027%[.-m" "")
        (case (a _) a)
        (vim.fn.trim)))

  (fn open_doc_window [content title]
    (local text (process_content content))
    (open_hover_window text title
                       (fn [bufid _winid]
                         (tset vim.bo bufid :filetype :markdown))))

  (local q (if (on_v_modes) (get_current_selection_text)
               (vim.fn.expand "<cword>")))
  (local cmd (make_cmd q))
  (local cmd_str (table.concat cmd " "))
  (print cmd_str " ...")
  (vim.system cmd {:text true :stdin (string.rep "y\n" 10)}
              (fn [res]
                (print "")
                (if (or (not= 0 res.code) (not res.stdout) (= "" res.stdout))
                    (vim.print cmd_str res)
                    ((vim.schedule_wrap open_doc_window) res.stdout cmd_str)))))

(fn add_keymaps_for_lfe_doc [bufid]
  (nvmap! "<Leader>k" (partial lfe_doc :h)
          {:buffer bufid :desc "[base] lfe (h mod fun arity)"})
  (nvmap! "<Leader>K" (partial lfe_doc :m)
          {:buffer bufid :desc "[base] lfe (m mod)"}))

(autocmd! :FileType
          {:desc "[LFE] add keymaps for (m mode) or (h mod fun arity)"
           :pattern :lfe
           :callback #(add_keymaps_for_lfe_doc $.buf)})

;; === RUN_VISUAL ===

(require :core.run_visual)
