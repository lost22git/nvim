vim.cmd [[
  FVimCursorSmoothMove v:true
  FVimCursorSmoothBlink v:true

  FVimBackgroundComposition 'blur'
  FVimBackgroundOpacity 0.66
  FVimBackgroundAltOpacity 0.66

  FVimCustomTitleBar v:true
  FVimUIPopupMenu v:true
  FVimDrawFPS v:true

  FVimKeyAutoIme v:true
  FVimKeyAltGr v:true

  FVimDefaultWindowWidth 800
  FVimDefaultWindowHeight 600

  FVimFontAntialias v:true
  FVimFontAutohint v:true
  FVimFontHintLevel 'full'
  FVimFontLigature v:true
  FVimFontLineHeight '+1.0'
  FVimFontSubpixel v:false
  FVimFontNoBuiltinSymbols v:true
  FVimFontAutoSnap v:true
  FVimFontNormalWeight 100
  FVimFontBoldWeight 400
]]

local map = vim.keymap
map.set({ '', 'i' }, '<M-Enter>', ':FVimToggleFullScreen<CR>')
map.set({ '', 'i' }, '<M-9>', ':messages<CR>')
map.set({ '', 'i' }, '<C-ScrollWheelUp>', ':set guifont=+<CR>')
map.set({ '', 'i' }, '<C-ScrollWheelDown>', ':set guifont=-<CR>')
map.set({ '' }, 'zi', ':set guifont=+<CR>')
map.set({ '' }, 'zo', ':set guifont=-<CR>')

