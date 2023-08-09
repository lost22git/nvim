vim.cmd [[
  FVimCursorSmoothMove v:true
  FVimCursorSmoothBlink v:true

  FVimBackgroundComposition 'blur'
  FVimBackgroundOpacity 0.8
  FVimBackgroundAltOpacity 0.8
  FVimCustomTitleBar v:true
  FVimUIPopupMenu v:false
  FVimDrawFPS v:true

  FVimKeyAutoIme v:true
  FVimKeyAltGr v:true
]]

local map = vim.keymap
map.set({ '', 'i' }, '<M-Enter>', ':FVimToggleFullScreen<CR>')
-- map.set({ '', 'i' }, '<M-9>', ':messages<CR>')
map.set({ '', 'i' }, '<C-ScrollWheelUp>', ':set guifont=+<CR>')
map.set({ '', 'i' }, '<C-ScrollWheelDown>', ':set guifont=-<CR>')
