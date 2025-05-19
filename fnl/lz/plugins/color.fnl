[{1 "NvChad/nvim-colorizer.lua"
  :cmd :ColorizerAttachToBuffer
  :opts {:user_default_options {:tailwind true
                                :mode :virtualtext
                                :virtualtext_inline :before}}}
 ;; Jetbrains IDEA
 {1 "nickkadutskyi/jb.nvim"
  :lazy false
  :priority 1000
  :opts {:transparent false :disable_hl_args {:bold false :italic true}}}
 ;; Helix
 {1 "oneslash/helix-nvim"
  :lazy false
  :priority 1000
  ; :init #(vim.cmd.colorscheme :helix)
  }
 ;; J.Blow
 {1 "whizikxd/naysayer-colors.nvim"
  :lazy false
  :priority 1000
  :init #(vim.cmd.colorscheme :naysayer)}
 ;; Cyberdream
 {1 "scottmckendry/cyberdream.nvim"
  :lazy false
  :priority 1000
  :opts {:variant :light :transparent false :cache true}}
 ;; Dayfox
 {1 "EdenEast/nightfox.nvim"
  :lazy false
  :priority 1000
  :opts {:groups {:all {:MiniCursorWord {:link :Underlined}
                        :MiniCursorWordCurrent {:link :Underlined}}}}
  ; :init #(vim.cmd.colorscheme :dayfox)
  }
 ;; Papercolor
 {1 "pappasam/papercolor-theme-slim"
  :lazy false
  :priority 1000
  ; :init #(vim.cmd.colorscheme :PaperColorSlimLight)
  }]
