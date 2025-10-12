(local nvim_help {:name "[hover] nvim help"
                  :event :FileType
                  :pattern [:lua :fennel]
                  :key "<Leader>K"
                  :mode [:n :v]
                  :run (fn [{: text}]
                         (vim.cmd (.. "help " text)))})

(local arturo_info
       {:name "[hover] arturo info"
        :event :FileType
        :pattern :arturo
        :key "<Leader>k"
        :mode [:n :v]
        :run (fn [{: text : open_hover_window}]
               (local cmd
                      ["sh"
                       "-c"
                       (.. "echo \"info '" text "\" | arturo --no-color")])
               (vim.notify (table.concat cmd " ") vim.log.levels.INFO)

               (fn on_exit [res cmd open_hover_window]
                 (local out (-> (if (= res.stderr "") res.stdout res.stderr)
                                (string.match "(%$%>.+)%s*%$%>")
                                (string.gsub "\027%[.-m" "")
                                (case (a _) a)
                                (vim.fn.trim)))
                 (local title (table.concat cmd " "))

                 (fn cb [bufid _winid]
                   (tset vim.bo bufid :filetype :arturo))

                 (open_hover_window out title cb))

               (vim.system cmd {:text true}
                           #((vim.schedule_wrap on_exit) $ cmd
                                                         open_hover_window)))})

(local lfe_info_fun
       {:name "[hover] lfe (h mod fun arity)"
        :event :FileType
        :pattern :lfe
        :key "<Leader>k"
        :mode [:n :v]
        :run (fn [{: text : open_hover_window}]
               (local cmd ["lfe"
                           "-e"
                           (do
                             (local [m fa] (vim.split text ":"))
                             (local [f a] (if fa (vim.split fa "/") []))
                             (.. "(h" ;;
                                 (if m (.. " '" m) "") ;; mode
                                 (if f (.. " '" f) "") ;; func
                                 (if a (.. " " a) "") ;; arity
                                 ")"))])
               (vim.notify (table.concat cmd " ") vim.log.levels.INFO)

               (fn on_exit [res cmd open_hover_window]
                 (local out (-> (if (= res.stderr "") res.stdout res.stderr)
                                (string.gsub "\027%[.-m" "")
                                (case (a _) a)
                                (vim.fn.trim)))
                 (local title (table.concat cmd " "))
                 (open_hover_window out title nil))

               (vim.system cmd {:text true :stdin (string.rep "y\n" 10)}
                           #((vim.schedule_wrap on_exit) $ cmd
                                                         open_hover_window)))})

(local lfe_info_mod
       {:name "[hover] lfe (m mod)"
        :event :FileType
        :pattern :lfe
        :key "<Leader>K"
        :mode [:n :v]
        :run (fn [{: text : open_hover_window}]
               (local cmd ["lfe" "-e" (.. "(m '" text ")")])
               (vim.notify (table.concat cmd " ") vim.log.levels.INFO)

               (fn on_exit [res cmd open_hover_window]
                 (local out (-> (if (= res.stderr "") res.stdout res.stderr)
                                (string.gsub "\027%[.-m" "")
                                (case (a _) a)
                                (vim.fn.trim)))
                 (local title (table.concat cmd " "))
                 (open_hover_window out title nil))

               (vim.system cmd {:text true :stdin (string.rep "y\n" 10)}
                           #((vim.schedule_wrap on_exit) $ cmd
                                                         open_hover_window)))})

[{1 "lost22git/hover.nvim"
  :lazy false
  :opts {:items [nvim_help arturo_info lfe_info_fun lfe_info_mod]}}]
