(import-macros {: autocmd!} :config.macros)

(local ft-colors {:clojure {:dark :duskfox :light :dayfox}
                  :crystal {:dark :vanta}
                  :java :jb
                  :nim {:dark :vanta}})

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
 ;; Jetbrains IDEA
 {1 "nickkadutskyi/jb.nvim"
  :lazy false
  :priority 1000
  :opts {:disable_hl_args {:bold false :italic true}}
  ;; :init #(vim.cmd.colorscheme :jb)
  }
 ;; fleet
 {1 "razcoen/fleet.nvim"
  :lazy false
  :priority 1000
  ;; :init #(vim.cmd.colorscheme :fleet)
  }
 ;; nightfox
 {1 "EdenEast/nightfox.nvim"
  :lazy false
  :priority 1000
  :opts {:groups {:all {:MiniCursorWord {:link :Underlined}
                        :MiniCursorWordCurrent {:link :Underlined}}}}
  ;; :init #(vim.cmd.colorscheme (case vim.o.background
  ;;                               :light :dayfox
  ;;                               :dark :carbonfox))
  }
 ;; papercolor
 {1 "pappasam/papercolor-theme-slim"
  :lazy false
  :priority 1000
  ;; :init #(vim.cmd.colorscheme (case vim.o.background
  ;;                               :dark :PaperColorSlim
  ;;                               :light :PaperColorSlimLight))
  }
 {1 "emanuel2718/vanta.nvim"
  :lazy false
  :priority 1000
  ;; :init #(vim.cmd.colorscheme :vanta)
  :opts {:italic {:strings false
                  :comments false
                  :operators false
                  :emphasis false
                  :folds false}}}
 {1 "ptdewey/monalisa-nvim"
  :lazy false
  :priority 1000
  ;; :init #(vim.cmd.colorscheme :monalisa)
  }]
