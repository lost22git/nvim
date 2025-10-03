(import-macros {: autocmd!} :config.macros)

(local ft-colors {:clojure :jb
                  :fennel :jb
                  :janet :jb
                  :crystal :jb
                  :java :jb
                  :nim :jb
                  :python :jb
                  :swift :jb
                  :elixir {:dark :duskfox :light :dayfox}
                  :gleam {:dark :duskfox :light :dayfox}
                  :javascript :jb
                  :typescript :jb})

(fn get-ft-color [ft]
  (local v (. ft-colors ft))
  (case (type v)
    :string v
    :table (. v vim.o.background)))

(autocmd! :FileType {:desc "change colorscheme for filetype"
                     :pattern (vim.tbl_keys ft-colors)
                     :nested true
                     :callback (fn [ev]
                                 (-> ev.match
                                     get-ft-color
                                     vim.cmd.colorscheme)
                                 nil)})

[{1 "NvChad/nvim-colorizer.lua"
  :cmd :ColorizerAttachToBuffer
  :opts {:user_default_options {:tailwind true
                                :mode :virtualtext
                                :virtualtext_inline :before}}}
 {1 "uga-rosa/ccc.nvim"
  :cmd [:CccPick :CccCovert :CccHighlighterToggle]
  :opts {}}
 ;; === ColorScheme ===
 ;; Jetbrains IDEA
 {1 "nickkadutskyi/jb.nvim"
  :lazy false
  :priority 1000
  :opts {:disable_hl_args {:bold false :italic true}}}
 ;; nightfox
 {1 "EdenEast/nightfox.nvim"
  :lazy false
  :priority 1000
  :opts {:groups {:all {:MiniCursorWord {:link :Underlined}
                        :MiniCursorWordCurrent {:link :Underlined}}}}}
 ;; papercolor
 {1 "pappasam/papercolor-theme-slim" :lazy false :priority 1000}
 ;; cyberdream
 {1 "scottmckendry/cyberdream.nvim" :lazy false :priority 1000}
 ;; monokai
 {1 "khoido2003/monokai-v2.nvim" :lazy false :priority 1000}]
