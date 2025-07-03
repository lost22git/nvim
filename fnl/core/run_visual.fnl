(import-macros {: has! : autocmd! : bufusercmd!} :config.macros)

(local {: create_keymaps_for_goto_entry : get_last_selection_text}
       (require :core.utils))

;; run_visual state
(local run_visual {:state {:bufid nil :winid nil}})

(fn run_visual.buffer_append [lines]
  "Append the given lines to buffer and scroll cursor to the bottom of window"
  (local {: bufid : winid} run_visual.state)
  (var line_start (vim.api.nvim_buf_line_count bufid))
  (when (= 1 line_start) (set line_start 0))
  (vim.api.nvim_buf_set_lines bufid line_start -1 false lines)
  (vim.api.nvim_win_set_cursor winid [(vim.api.nvim_buf_line_count bufid) 0]))

(fn run_visual.write_selection_to_tmp_file []
  "Read selection text and write to temp file"
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
  "Create buffer or window if not exist"
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
          {:desc "Create [RunVisual] usercommand"
           :callback #(bufusercmd! $.buf :RunVisual
                                   (fn [{: fargs}]
                                     (local tmp_file
                                            (run_visual.write_selection_to_tmp_file))
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
                                              (case obj.code
                                                0 obj.stdout
                                                code (.. "💀 Code: " code
                                                         "\n"
                                                         (if (= obj.stderr "")
                                                             obj.stdout
                                                             obj.stderr))))
                                       (-> text
                                           (string.gsub "\027%[.-m" "")
                                           (case (a _) a)
                                           (vim.fn.trim)
                                           (vim.fn.split "\n" true)
                                           (run_visual.buffer_append)))

                                     ;; run cmd
                                     (vim.system cmd {:text true}
                                                 (vim.schedule_wrap print_cmd_result)))
                                   {:nargs "+" :range true})})

(autocmd! :FileType
          {:desc "[RunVisual] add keymaps for goto prev/next log"
           :pattern :RunVisual
           :callback #(create_keymaps_for_goto_entry "\\v^# \\-+$" "[e" "]e"
                                                     :run_visual_log $.buf)})
