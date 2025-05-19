(import-macros {: autocmd : bufusercmd : nmap} :config.macros)

[{1 "jellydn/hurl.nvim"
  :ft :hurl
  :opts {:debug false
         :show_notification false
         :mode :split
         :formatters {:json ["jq"] :html ["prettier" "--parser" "html"]}}
  :init (fn []
          (fn create_keymaps [bufid]
            (local p "\\v^<(HEAD|GET|POST|PUT|PATCH|DELETE|OPTION)>")
            (nmap "[e" (string.format "<Cmd>call search('%s', 'bw')<CR>" p)
                  {:buffer bufid :silent true :desc "[hurl] Goto prev entry"})
            (nmap "]e" (string.format "<Cmd>call search('%s', 'w')<CR>" p)
                  {:buffer bufid :silent true :desc "[hurl] Goto next entry"})
            (nmap "<Leader>ee" "<Cmd>HurlRunnerAt<CR>"
                  {:buffer bufid :silent true :desc "[hurl] HurlRunnerAt"})
            (nmap "<Leader>eb" "<Cmd>HurlRunner<CR>"
                  {:buffer bufid :silent true :desc "[hurl] HurlRunner"}))

          (autocmd :FileType
                   {:pattern :hurl :callback #(create_keymaps $1.buf)}))}
 {1 "mistweaverco/kulala.nvim"
  :ft [:http :rest]
  :opts {:winbar true :show_variable_info_text :float}
  :init (fn []
          (fn create_usercmds [bufid]
            (local data
                   [[:Run :run]
                    [:RunAll :run_all]
                    [:ToggleView :toggle_view]
                    [:Relay :relay]
                    [:Open :open]
                    [:Inspect :inspect]
                    [:ShowStats :show_stats]
                    [:Copy :copy]
                    [:FromCurl :from_curl]
                    [:Search :search]
                    [:JumpPrev :jump_prev]
                    [:JumpNext :jump_next]
                    [:ClearCachedFiles :clear_cached_files]
                    [:Scratchpad :scratchpad]
                    [:DownloadGraphqlSchema :download_graphql_schema]])
            (each [_ [k v] (pairs data)]
              (bufusercmd bufid (.. :Kulala k) #((. (require :kulala) v))
                          {:nargs 0}))
            (bufusercmd bufid "KulalaScriptsClearGlobal"
                        (fn [o]
                          ((. (require :kulala) :scripts_clear_global) (unpack o.fargs)))
                        {:nargs "*"}))

          (fn create_keymaps [bufid]
            (local data
                   [["<Leader>ee" "<Cmd>KulalaRun<CR>"]
                    ["<Leader>E" "<Cmd>KulalaSearch<CR>"]
                    ["<Leader>eb" "<Cmd>KulalaRunAll<CR>"]
                    ["[e" "<Cmd>KulalaJumpPrev<CR>"]
                    ["]e" "<Cmd>KulalaJumpNext<CR>"]
                    ["<Leader>ls" "<Cmd>KulalaOpen<CR>"]])
            (each [_ [k v] (pairs data)]
              (nmap k v {:buffer bufid :silent true})))

          (autocmd :FileType
                   {:pattern [:http :rest]
                    :callback (fn [ev]
                                (create_usercmds ev.buf)
                                (create_keymaps ev.buf))}))}]
