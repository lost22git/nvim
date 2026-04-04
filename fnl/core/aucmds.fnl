(import-macros {: has! : on! : bufusercmd! : nmap! : nvmap! : nvomap!}
               :config.macros)

(local {: create_keymaps_for_goto_entry} (require :core.utils))

(on! :FileType {:desc "Set fileformat to unix"
                :pattern "*"
                :callback #(when (and vim.bo.modifiable
                                      (not (vim.list_contains [:qf :FTerm]
                                                              vim.bo.filetype)))
                             (set vim.bo.fileformat :unix))})

(on! :TextYankPost
     {:desc "Highlight yanked text"
      :pattern "*"
      :callback #(vim.hl.on_yank {:higroup :Visual :timeout 200})})

(on! :BufReadPost
     {:desc "Restore cursor position"
      :callback #(vim.cmd "silent! normal! g`\"zv")})

(on! :FileType {:desc "Do not list quickfix buffers"
                :pattern :qf
                :callback #(set vim.opt_local.buflisted false)})

(on! :BufWinEnter
     {:desc "Add keymaps for Goto prev/next region"
      :callback #(create_keymaps_for_goto_entry "[-\\/;#\\*] === .\\+ ===" "[r"
                                                "]r" :code_region $.buf)})

;; === CURSOR STYLE ===

(var GUI_CURSOR_CACHE nil)

(on! :VimSuspend {:desc "[Cursor Style] Cache nvim cursor style"
                  :pattern "*"
                  :callback (fn []
                              (set GUI_CURSOR_CACHE (vim.opt.guicursor:get))
                              (set vim.opt.guicursor {})
                              nil)})

(on! :VimResume
     {:desc "[Cursor Style] Restore nvim cursor style"
      :pattern "*"
      :callback #(when GUI_CURSOR_CACHE
                   (set vim.opt.guicursor GUI_CURSOR_CACHE))})

;; === TMUX ===

(when (?. vim.env :TMUX)
  (on! :BufWritePost {:desc "[Tmux] Reload tmux config after [.tmux.conf] saved"
                      :pattern ".tmux.conf"
                      :callback #(let [cmd (.. "tmux source-file "
                                               (vim.api.nvim_buf_get_name $.buf))]
                                   (vim.fn.system cmd)
                                   nil)}))

;; === JUST ===

(on! :FileType
     {:desc "[Just] add keymaps for Goto prev/next task"
      :pattern :just
      :callback #(create_keymaps_for_goto_entry "\\v^\\w+.*:$" "[e" "]e"
                                                :just_task $.buf)})

;; === HTTP ===

(on! :FileType
     {:desc "[Http] add keymaps for Goto prev/next http request"
      :pattern [:http :rest :hurl]
      :callback #(create_keymaps_for_goto_entry "\\v^<(HEAD|GET|POST|PUT|PATCH|DELETE|OPTION)>"
                                                "[e" "]e" :http_request $.buf)})

;; === CLOJURE ===

(on! :FileType
     {:desc "[Clojure] add keymaps for Goto prev/next (comment)"
      :pattern [:clojure :janet]
      :callback #(create_keymaps_for_goto_entry "\\v(^\\(comment|^#_)" "[C"
                                                "]C" :comment_form $.buf)})

(fn start-clojure-nrepl-server [args]
  (let [clj_opts (if (string.match args "%-M:")
                     args
                     (.. args " -M"))
        deps "'{:deps {nrepl/nrepl {:mvn/version \"1.3.0\"} refactor-nrepl/refactor-nrepl {:mvn/version \"3.10.0\"} cider/cider-nrepl {:mvn/version \"0.52.0\"} }}'"
        cider_opts "\"(require 'nrepl.cmdline) (nrepl.cmdline/-main \\\"--interactive\\\" \\\"--middleware\\\" \\\"[refactor-nrepl.middleware/wrap-refactor cider.nrepl/cider-middleware]\\\")\""
        cmd (string.format "clj -Sdeps %s %s -e %s" deps clj_opts cider_opts)]
    (vim.cmd (.. "tabnew | term " cmd))))

(on! :FileType {:desc "[Clojure] add `Clj` usercommand for starting Clojure nREPL server"
                :pattern :clojure
                :callback #(bufusercmd! $.buf :Clj
                                        (fn [{: args}]
                                          (start-clojure-nrepl-server args))
                                        {:nargs "*"})})

;; === JANET ===

(on! :FileType {:desc "[Janet] add `Janet` usercommand for starting janet-netrepl server"
                :pattern :janet
                :callback #(bufusercmd! $.buf :Janet
                                        #(vim.cmd (.. "tabnew | term "
                                                      "janet-netrepl"))
                                        {:nargs "*"})})

;; === LISP ===

(on! :FileType {:desc "[SBCL] add `SBCL` usercommand for starting swank server"
                :pattern :lisp
                :callback #(bufusercmd! $.buf :SBCL
                                        #(->> "sbcl --eval \"(ql:quickload :swank)\" --eval \"(swank:create-server :dont-close t)\""
                                              (.. "tabnew | term ")
                                              (vim.cmd))
                                        {:nargs "*"})})

;; === BASILISP ===

(on! :FileType {:desc "[Basilisp] add `Basilisp` usercommand for starting Basilisp nrepl server"
                :pattern :clojure
                :callback #(bufusercmd! $.buf :Basilisp
                                        #(vim.cmd (.. "tabnew | term "
                                                      "basilisp nrepl-server"))
                                        {:nargs "*"})})
