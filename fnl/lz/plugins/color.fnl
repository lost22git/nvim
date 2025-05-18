[{1 "NvChad/nvim-colorizer.lua"
  :cmd :ColorizerAttachToBuffer
  :opts {:user_default_options {:tailwind true
                                :mode :virtualtext
                                :virtualtext_inline :before}}}
 ;; Jetbrains IDEA
 {1 "nickkadutskyi/jb.nvim"
  :lazy false
  :opts {:transparent false :disable_hl_args {:bold false :italic true}}}
 ;; Helix
 {1 "oneslash/helix-nvim" :lazy false}
 ;; J.Blow
 {1 "whizikxd/naysayer-colors.nvim" :lazy false}
 ;; Cyberdream
 {1 "scottmckendry/cyberdream.nvim"
  :lazy false
  :opts {:variant :light :transparent false :cache true}}
 ;; Dayfox
 {1 "EdenEast/nightfox.nvim"
  :lazy false
  :opts {:groups {:all {:MiniCursorWord {:link :Underlined}
                        :MiniCursorWordCurrent {:link :Underlined}}}}
  :init (fn [] (vim.cmd.colorscheme :dayfox))}
 ;; Papercolor
 {1 "pappasam/papercolor-theme-slim" :lazy false}]
