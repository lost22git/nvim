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
  :init #(vim.cmd.colorscheme :fleet)}
 ;; helix
 {1 "oneslash/helix-nvim"
  :lazy false
  :priority 1000
  ;; :init #(vim.cmd.colorscheme :helix)
  }
 ;; nightfox
 {1 "EdenEast/nightfox.nvim"
  :lazy false
  :priority 1000
  :opts {:groups {:all {:MiniCursorWord {:link :Underlined}
                        :MiniCursorWordCurrent {:link :Underlined}}}}
  ;; :init #(vim.cmd.colorscheme :dayfox)
  }
 ;; papercolor
 {1 "pappasam/papercolor-theme-slim"
  :lazy false
  :priority 1000
  ;; :init #(vim.cmd.colorscheme (case vim.o.background
  ;;                               :dark :PaperColorSlim
  ;;                               :light :PaperColorSlimLight))
  }
 ;; base16
 {1 "RRethy/base16-nvim"
  :lazy false
  :priority 1000
  :init #(case vim.o.background
           :light (vim.cmd.colorscheme :base16-cupertino))}
 {1 "emanuel2718/vanta.nvim"
  :lazy false
  :priority 1000
  ;; :init #(vim.cmd.colorscheme :vanta)
  :opts {:italic {:strings false
                  :comments false
                  :operators false
                  :emphasis false
                  :folds false}}}
 {1 "olivercederborg/poimandres.nvim"
  :lazy false
  :priority 1000
  ;; :init #(vim.cmd.colorscheme :poimandres)
  }
 {1 "ptdewey/monalisa-nvim"
  :lazy false
  :priority 1000
  ;; :init #(vim.cmd.colorscheme :monalisa)
  }
 {1 "ptdewey/darkearth-nvim"
  :lazy false
  :priority 1000
  ;; :init #(vim.cmd.colorscheme :darkearth)
  }]
