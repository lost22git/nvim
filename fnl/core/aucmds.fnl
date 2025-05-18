(import-macros {: autocmd : bufusercmd : nvmap : nvomap} :config.macros)

;; Register filetypes
(vim.cmd "
  au BufNewFile,BufReadPost *.bb set filetype=clojure
  au BufNewFile,BufReadPost *.c3 set filetype=c3
  au BufNewFile,BufReadPost *.cljd set filetype=clojure
  au BufNewFile,BufReadPost *.cy set filetype=cyber
  au BufNewFile,BufReadPost *.http set filetype=http
  au BufNewFile,BufReadPost *.kk set filetype=koka
  au BufNewFile,BufReadPost *.lfe set filetype=lfe
  au BufNewFile,BufReadPost *.lobster set filetype=lobster
  au BufNewFile,BufReadPost *.postcss set filetype=postcss
  au BufNewFile,BufReadPost *.v set filetype=vlang
")

;; Register commentstring
(vim.cmd "
  au FileType c3 setlocal commentstring=//\\ %s
  au FileType cyber setlocal commentstring=--\\ %s
  au FileType http setlocal commentstring=#\\ %s
  au FileType inko setlocal commentstring=#\\ %s
  au FileType janet setlocal commentstring=#\\ %s
  au FileType json setlocal commentstring=//\\ %s
  au FileType just setlocal commentstring=#\\ %s
  au FileType koka setlocal commentstring=//\\ %s
  au FileType lfe setlocal commentstring=;\\ %s
  au FileType lobster setlocal commentstring=//\\ %s
")

(when (?. vim.env :TMUX)
  (vim.cmd "
    augroup tmux_status_bar_toggle
      autocmd VimEnter,VimResume  * call system('tmux set status off')
      autocmd VimLeave,VimSuspend * call system('tmux set status on')
    augroup END
  "))

(var GUI_CURSOR_CACHE nil)

(autocmd [:VimLeave :VimSuspend]
         {:desc "restore terminal cursor style"
          :pattern "*"
          :callback (fn []
                      (set GUI_CURSOR_CACHE (vim.opt.guicursor:get))
                      (set vim.opt.guicursor {})
                      ;; \x1b[?12l -> disable cursor blink
                      ;; \x1b[6 q -> set cursor style to bar
                      (vim.fn.chansend vim.v.stderr "\x1b[6 q \x1b[?12l"))})

(autocmd :VimResume
         {:desc "restore nvim cursor style"
          :pattern "*"
          :callback (fn []
                      (when GUI_CURSOR_CACHE
                        (set vim.opt.guicursor GUI_CURSOR_CACHE)))})

(autocmd :FileType
         {:desc "set fileformat to unix"
          :pattern "*"
          :callback (fn []
                      (when (and vim.bo.modifiable
                                 (not (vim.tbl_contains [:qf :FTerm]
                                                        vim.bo.filetype)))
                        (set vim.bo.fileformat :unix)))})

(autocmd :TextYankPost
         {:desc "highlight yanked text"
          :pattern "*"
          :callback (partial vim.hl.on_yank {:higroup :Visual :timeout 200})})

(autocmd :BufWinEnter
         {:desc "add keymaps for Goto prev/next region"
          :callback (fn []
                      (local p "[-\\/;#] === .\\+ ===$")
                      (nvomap "[r"
                              (string.format "<Cmd>call search('%s','bw')<CR>"
                                             p)
                              {:silent true
                               :buffer true
                               :desc "[base] Goto prev region"})
                      (nvomap "]r"
                              (string.format "<Cmd>call search('%s','w')<CR>" p)
                              {:silent true
                               :buffer true
                               :desc "[base] Goto next region"}))})

(autocmd :FileType
         {:desc "[Clojure] add keymaps for Goto prev/next (comment)"
          :pattern [:clojure :janet]
          :callback (fn []
                      (local p "\\v(^\\(comment|^#_)")
                      (nvomap "[C"
                              (string.format "<Cmd>call search('%s','bw')<CR>"
                                             p)
                              {:silent true
                               :buffer true
                               :desc "[base] Clojure goto prev comment"})
                      (nvomap "]C"
                              (string.format "<Cmd>call search('%s','w')<CR>" p)
                              {:silent true
                               :buffer true
                               :desc "[base] Clojure goto next comment"}))})

(autocmd :FileType
         {:desc "[Just] add keymaps for Goto prev/next task"
          :pattern :just
          :callback (fn []
                      (local p "\\v^\\w+.*:$")
                      (nvomap "[e"
                              (string.format "<Cmd>call search('%s','bw')<CR>"
                                             p)
                              {:silent true
                               :buffer true
                               :desc "[base] Justfile goto prev task"})
                      (nvomap "]e"
                              (string.format "<Cmd>call search('%s','w')<CR>" p)
                              {:silent true
                               :buffer true
                               :desc "[base] Justfile goto next task"}))})

(fn nvim_help []
  (local {: on_v_modes : get_current_selection_text} (require :core.utils))
  (local q (if (on_v_modes) (get_current_selection_text)
               (vim.fn.expand "<cword>")))
  (vim.cmd (.. "help " q)))

(autocmd :FileType {:desc "add keymaps for nvim help"
                    :pattern :lua
                    :callback (fn [ev]
                                (fn cb []
                                  (local bufid ev.buf)
                                  (when (= 1 (vim.fn.bufexists bufid))
                                    (nvmap "<Leader>k" nvim_help
                                           {:buffer bufid
                                            :desc "[base] Nvim help"})))

                                (vim.defer_fn cb 1000))})

(var add_keymaps_for_docr nil)
(fn docr [subcmd]
  (fn open_doc_window [obj title]
    (print "")
    (local text (vim.fn.trim (assert obj.stdout)))
    (local {: open_hover_window} (require :core.utils))
    (open_hover_window text title
                       (fn [bufid winid]
                         (tset vim.bo bufid :filetype :markdown)
                         (add_keymaps_for_docr bufid))))

  (local {: on_v_modes : get_current_selection_text} (require :core.utils))
  (local q (if (on_v_modes) (get_current_selection_text)
               (vim.fn.expand "<cword>")))
  (local cmd ["docr" subcmd (.. "'" (vim.fn.escape q "'") "'")])
  (local cmd_str (table.concat cmd " "))
  (print cmd_str " ...")
  (vim.system cmd {:text true}
              (fn [res]
                (if (or (not= 0 res.code) (not res.stdout) (= "" res.stdout))
                    (vim.print cmd_str res)
                    ((vim.schedule_wrap open_doc_window) res cmd_str)))))

(set add_keymaps_for_docr
     (fn [bufid]
       (nvmap "<Leader>k" (partial docr :info)
              {:buffer bufid :desc "[base] docr info"})
       (nvmap "<Leader>K" (partial docr :search)
              {:buffer bufid :desc "[base] docr search"})
       (nvmap "<Leader>kk" (partial docr :tree)
              {:buffer bufid :desc "[base] docr tree"})))

(autocmd :FileType
         {:desc "[Crystal] add keymaps for docr"
          :pattern :crystal
          :callback #(add_keymaps_for_docr $1.buf)})

(fn lfe_doc [m_or_h]
  (fn open_doc_window [obj title]
    (print "")
    (local text (vim.fn.trim (assert obj.stdout)))
    (local {: open_hover_window} (require :core.utils))
    (open_hover_window text title
                       (fn [bufid winid]
                         (tset vim.bo bufid :filetype :markdown))))

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

  (local {: on_v_modes : get_current_selection_text} (require :core.utils))
  (local q (if (on_v_modes) (get_current_selection_text)
               (vim.fn.expand "<cword>")))
  (local cmd (make_cmd q))
  (local cmd_str (table.concat cmd " "))
  (print cmd_str " ...")
  (vim.system cmd {:text true :stdin (string.rep "y\n" 10)}
              (fn [res]
                (if (or (not= 0 res.code) (not res.stdout) (= "" res.stdout))
                    (vim.print cmd_str res)
                    ((vim.schedule_wrap open_doc_window) res cmd_str)))))

(autocmd :FileType
         {:desc "[LFE] add keymaps for (m mode) or (h mod fun arity)"
          :pattern :lfe
          :callback (fn [ev]
                      (nvmap "<Leader>k" (partial lfe_doc :h)
                             {:buffer ev.buf
                              :desc "[base] lfe (h mod fun arity)"})
                      (nvmap "<Leader>K" (partial lfe_doc :m)
                             {:buffer ev.buf :desc "[base] lfe (m mod)"}))})

(autocmd :FileType {:desc "[Clojure] add `Clj` usercommand for starting Clojure nREPL server"
                    :pattern :clojure
                    :callback (fn []
                                (bufusercmd 0 :Clj
                                            (fn [opts]
                                              (local clj_opts
                                                     (if (string.match opts.args
                                                                       "%-M:")
                                                         opts.args
                                                         (.. opts.args " " "-M")))
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
                                            {:nargs "*"}))})

(autocmd :FileType {:desc "[Janet] add `JanetNetrepl` usercommand for starting janet-netrepl server"
                    :pattern :janet
                    :callback #(bufusercmd $1.buf :JanetNetrepl
                                           #(vim.cmd (.. "tabnew | term "
                                                         "janet-netrepl"))
                                           {:nargs "*"})})
