(import-macros {: has! : autocmd! : bufusercmd! : nvmap! : nvomap!}
               :config.macros)

(local {: create_keymaps_for_goto_entry
        : on_v_modes
        : get_current_selection_text
        : get_last_selection_text
        : open_hover_window} (require :core.utils))

;; Register filetypes
(vim.cmd "
  au BufNewFile,BufReadPost *.bb set filetype=clojure
  au BufNewFile,BufReadPost *.c3 set filetype=c3
  au BufNewFile,BufReadPost *.cljd set filetype=clojure
  au BufNewFile,BufReadPost *.cy set filetype=cyber
  au BufNewFile,BufReadPost *.flix set filetype=flix
  au BufNewFile,BufReadPost *.http set filetype=http
  au BufNewFile,BufReadPost *.kk set filetype=koka
  au BufNewFile,BufReadPost *.lfe set filetype=lfe
  au BufNewFile,BufReadPost *.lobster set filetype=lobster
  au BufNewFile,BufReadPost *.n set filetype=nature
  au BufNewFile,BufReadPost *.postcss set filetype=postcss
  au BufNewFile,BufReadPost *.v set filetype=vlang
")

;; Register commentstring
(vim.cmd "
  au FileType c3 setlocal commentstring=//\\ %s
  au FileType crystal setlocal commentstring=#\\ %s
  au FileType cyber setlocal commentstring=--\\ %s
  au FileType fennel setlocal commentstring=;;\\ %s
  au FileType flix setlocal commentstring=//\\ %s
  au FileType http setlocal commentstring=#\\ %s
  au FileType inko setlocal commentstring=#\\ %s
  au FileType janet setlocal commentstring=#\\ %s
  au FileType json setlocal commentstring=//\\ %s
  au FileType just setlocal commentstring=#\\ %s
  au FileType koka setlocal commentstring=//\\ %s
  au FileType lfe setlocal commentstring=;\\ %s
  au FileType lobster setlocal commentstring=//\\ %s
  au FileType nature setlocal commentstring=//\\ %s
")

(when (?. vim.env :TMUX)
  (vim.cmd "
    augroup tmux_status_bar_toggle
      autocmd VimEnter,VimResume  * call system('tmux set status off')
      autocmd VimLeave,VimSuspend * call system('tmux set status on')
    augroup END
  "))

(var GUI_CURSOR_CACHE nil)

(autocmd! [:VimLeave :VimSuspend]
          {:desc "restore terminal cursor style"
           :pattern "*"
           :callback (fn []
                       (set GUI_CURSOR_CACHE (vim.opt.guicursor:get))
                       (set vim.opt.guicursor {})
                       ;; \x1b[?12l -> disable cursor blink
                       ;; \x1b[6 q -> set cursor style to bar
                       (vim.fn.chansend vim.v.stderr "\x1b[6 q \x1b[?12l"))})

(autocmd! :VimResume
          {:desc "restore nvim cursor style"
           :pattern "*"
           :callback #(when GUI_CURSOR_CACHE
                        (set vim.opt.guicursor GUI_CURSOR_CACHE))})

(autocmd! :FileType
          {:desc "set fileformat to unix"
           :pattern "*"
           :callback #(when (and vim.bo.modifiable
                                 (not (vim.tbl_contains [:qf :FTerm]
                                                        vim.bo.filetype)))
                        (set vim.bo.fileformat :unix))})

(autocmd! :TextYankPost
          {:desc "highlight yanked text"
           :pattern "*"
           :callback #(vim.hl.on_yank {:higroup :Visual :timeout 200})})

(autocmd! :BufWinEnter
          {:desc "add keymaps for Goto prev/next region"
           :callback #(create_keymaps_for_goto_entry "[-\\/;#] === .\\+ ===$"
                                                     "[r" "]r" :code_region
                                                     $.buf)})

(autocmd! :FileType
          {:desc "[Clojure] add keymaps for Goto prev/next (comment)"
           :pattern [:clojure :janet]
           :callback #(create_keymaps_for_goto_entry "\\v(^\\(comment|^#_)"
                                                     "[C" "]C" :comment_form
                                                     $.buf)})

(autocmd! :FileType
          {:desc "[Just] add keymaps for Goto prev/next task"
           :pattern :just
           :callback #(create_keymaps_for_goto_entry "\\v^\\w+.*:$" "[e" "]e"
                                                     :just_task $.buf)})

(autocmd! :FileType
          {:desc "[Http] add keymaps for Goto prev/next http request"
           :pattern [:http :rest :hurl]
           :callback #(create_keymaps_for_goto_entry "\\v^<(HEAD|GET|POST|PUT|PATCH|DELETE|OPTION)>"
                                                     "[e" "]e" :http_request
                                                     $.buf)})

(fn nvim_help []
  (local q (if (on_v_modes) (get_current_selection_text)
               (vim.fn.expand "<cword>")))
  (vim.cmd (.. "help " q)))

(autocmd! :FileType {:desc "add keymaps for nvim help"
                     :pattern :lua
                     :callback (fn [{:buf bufid}]
                                 (fn cb []
                                   (when (= 1 (vim.fn.bufexists bufid))
                                     (nvmap! "<Leader>k" nvim_help
                                             {:buffer bufid
                                              :desc "[base] Nvim help"})))

                                 (vim.defer_fn cb 1000))})

(var add_keymaps_for_docr nil)
(fn docr [subcmd]
  (fn open_doc_window [obj title]
    (print "")
    (local text (vim.fn.trim (assert obj.stdout)))
    (open_hover_window text title
                       (fn [bufid _winid]
                         (tset vim.bo bufid :filetype :markdown)
                         (add_keymaps_for_docr bufid))))

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

(fn lfe_doc [m_or_h]
  (fn open_doc_window [obj title]
    (print "")
    (local text (vim.fn.trim (assert obj.stdout)))
    (open_hover_window text title
                       (fn [bufid _winid]
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

(autocmd! :FileType
          {:desc "[LFE] add keymaps for (m mode) or (h mod fun arity)"
           :pattern :lfe
           :callback (fn [{:buf bufid}]
                       (nvmap! "<Leader>k" (partial lfe_doc :h)
                               {:buffer bufid
                                :desc "[base] lfe (h mod fun arity)"})
                       (nvmap! "<Leader>K" (partial lfe_doc :m)
                               {:buffer bufid :desc "[base] lfe (m mod)"}))})

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

;; run_visual state
(local run_visual {:state {:bufid nil :winid nil}})
(fn run_visual.buffer_append [lines]
  "Append given lines to buffer and scroll cursor to the bottom of window"
  (local {: bufid : winid} run_visual.state)
  (var line_start (vim.api.nvim_buf_line_count bufid))
  (when (= 1 line_start) (set line_start 0))
  (vim.api.nvim_buf_set_lines bufid line_start -1 false lines)
  (vim.api.nvim_win_set_cursor winid [(vim.api.nvim_buf_line_count bufid) 0]))

(fn run_visual.read_selection_and_write_to_tmp_file []
  ;; read selection_text
  (local selection_text (get_last_selection_text))
  ;; create tmp_file
  (local tmp_file (-> (os.tmpname)
                      (vim.fs.dirname)
                      (.. "/nvim_run_visual_tmp")))
  ;; write selection text to tmp_file
  (-> selection_text
      (vim.split "\n")
      (vim.fn.writefile tmp_file))
  ;; ensure tmp_file accessible
  (when (has! :unix)
    (os.execute (.. "chmod 777 " tmp_file)))
  tmp_file)

(fn run_visual.ensure_buf_and_win []
  ;; create buffer if not exists
  (when (or (not run_visual.state.bufid)
            (= 0 vim.fn.bufexists run_visual.state.bufid))
    (set run_visual.state.bufid (vim.api.nvim_create_buf false true))
    (tset vim.bo run_visual.state.bufid :filetype :RunVisual))
  ;; create window if not exists
  (when (not (and run_visual.state.winid
                  (vim.api.nvim_win_is_valid run_visual.state.winid)))
    (set run_visual.state.winid
         (vim.api.nvim_open_win run_visual.state.bufid false
                                {:split "below" :style :minimal}))))

(autocmd! :BufWinEnter
          {:desc "create `RunVisual` usercommand"
           :callback #(bufusercmd! $.buf :RunVisual
                                   (fn [{: fargs}]
                                     (local tmp_file
                                            (run_visual.read_selection_and_write_to_tmp_file))
                                     ;; make cmd
                                     (local cmd [(unpack fargs) tmp_file])
                                     ;; open buffer window to waiting for cmd result
                                     (run_visual.ensure_buf_and_win)
                                     (let [time_str (os.date "!%m-%d %H:%M:%S"
                                                             (os.time))
                                           title_lines [(.. "# "
                                                            (string.rep "-" 80))
                                                        (.. "# " time_str " - "
                                                            (table.concat cmd
                                                                          " "))]]
                                       (run_visual.buffer_append title_lines))

                                     (fn print_cmd_result [obj]
                                       (local text
                                              (if (and obj.stdout
                                                       (not= obj.stdout ""))
                                                  obj.stdout
                                                  (vim.inspect obj)))
                                       (-> text
                                           (vim.fn.trim)
                                           (vim.fn.split "\n" true)
                                           (run_visual.buffer_append)))

                                     ;; run cmd
                                     (vim.system cmd {:text true}
                                                 #((vim.schedule_wrap print_cmd_result) $)))
                                   {:nargs "+" :range true})})

(autocmd! :FileType
          {:desc "[RunVisual] add keymaps for goto prev/next log"
           :pattern :RunVisual
           :callback #(create_keymaps_for_goto_entry "\\v^# \\-+$" "[e" "]e"
                                                     :run_visual_log $.buf)})
