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
  :enabled false
  :lazy false
  :priority 1000
  :opts {:disable_hl_args {:bold false :italic true}}
  ;; :init #(vim.cmd.colorscheme :jb)
  }
 ;; Helix
 {1 "oneslash/helix-nvim"
  :enabled false
  :lazy false
  :priority 1000
  ;; :init #(vim.cmd.colorscheme :helix)
  }
 ;; Nightfox
 {1 "EdenEast/nightfox.nvim"
  :enabled false
  :lazy false
  :priority 1000
  :opts {:groups {:all {:MiniCursorWord {:link :Underlined}
                        :MiniCursorWordCurrent {:link :Underlined}}}}
  ; :init #(vim.cmd.colorscheme :dayfox)
  }
 ;; Papercolor
 {1 "pappasam/papercolor-theme-slim"
  :enabled false
  :lazy false
  :priority 1000
  ;; :init #(vim.cmd.colorscheme (case vim.o.background
  ;;                               :dark :PaperColorSlim
  ;;                               :light :PaperColorSlimLight))
  }
 ;; Base16
 {1 "RRethy/base16-nvim"
  :enabled false
  :lazy false
  :priority 1000
  ;; :init #(vim.cmd.colorscheme (case vim.o.background
  ;;                                 :dark :base16-ayu-dark
  ;;                                 :light :base16-ayu-light))
  }]
