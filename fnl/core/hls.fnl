(import-macros {: on!} :config.macros)

(fn do_hls []
  (vim.cmd "highlight! Pmenu ctermbg=NONE guibg=NONE
            highlight! link FloatBorder Normal
            highlight! link BlinkCmpDocBorder FloatBorder
            highlight! link BlinkCmpMenuBorder FloatBorder
            highlight! link BlinkCmpSignatureHelpBorder FloatBorder
            ")
  (when (not vim.g.zz.statusline)
    (vim.cmd "highlight! link StatusLine Normal
              highlight! link StatusLineNC Normal
             "))
  (when vim.g.zz.transparent
    (vim.cmd "highlight! Normal ctermbg=NONE guibg=NONE
              highlight! NormalNC ctermbg=NONE guibg=NONE
              highlight! NormalFloat ctermbg=NONE guibg=NONE
              highlight! EndOfBuffer ctermbg=NONE guibg=NONE
              ")))

(on! :ColorScheme {:callback #(do_hls)})

(do_hls)
