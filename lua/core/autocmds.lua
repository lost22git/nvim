GUI_CURSOR_CACHE = nil

vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
  desc = 'restore terminal cursor style',
  pattern = '*',
  callback = function()
    GUI_CURSOR_CACHE = vim.opt.guicursor:get()
    vim.opt.guicursor = {}

    -- \x1b[?12l -> disable cursor blink
    -- \x1b[6 q -> set cursor style to bar
    vim.fn.chansend(vim.v.stderr, '\x1b[6 q \x1b[?12l')
  end,
})

vim.api.nvim_create_autocmd('VimResume', {
  desc = 'restore nvim cursor style',
  pattern = '*',
  callback = function()
    if GUI_CURSOR_CACHE then vim.opt.guicursor = GUI_CURSOR_CACHE end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'set fileformat to unix',
  pattern = '*',
  callback = function()
    if not vim.bo.modifiable then return end
    local exclude_ftypes = { 'qf', 'FTerm' }
    local ft = vim.bo.filetype
    if vim.tbl_contains(exclude_ftypes, ft) then return end
    vim.bo.fileformat = 'unix'
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'highlight yanked text',
  pattern = '*',
  callback = function() vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 }) end,
})

-- Register filetypes
vim.cmd([[
  au BufNewFile,BufReadPost *.bb set filetype=clojure
  au BufNewFile,BufReadPost *.c3 set filetype=c3
  au BufNewFile,BufReadPost *.cljd set filetype=clojure
  au BufNewFile,BufReadPost *.cy set filetype=cyber
  au BufNewFile,BufReadPost *.http set filetype=http
  au BufNewFile,BufReadPost *.kk set filetype=koka
  au BufNewFile,BufReadPost *.lobster set filetype=lobster
  au BufNewFile,BufReadPost *.postcss set filetype=postcss
  au BufNewFile,BufReadPost *.v set filetype=vlang
]])

-- Register filetypes' commentstring
vim.cmd([[
  au FileType c3 setlocal commentstring=//\ %s
  au FileType cyber setlocal commentstring=--\ %s
  au FileType http setlocal commentstring=#\ %s
  au FileType inko setlocal commentstring=#\ %s
  au FileType janet setlocal commentstring=#\ %s
  au FileType json setlocal commentstring=//\ %s
  au FileType just setlocal commentstring=#\ %s
  au FileType koka setlocal commentstring=//\ %s
  au FileType lobster setlocal commentstring=//\ %s
]])

vim.api.nvim_create_autocmd('FileType', {
  desc = 'add keymaps for Goto prev/next region',
  pattern = { '*' },
  callback = function()
    local p = [[[-\/;#] === .\+ ===$]]
    local prev = string.format([[<Cmd>call search('%s','bw')<CR>]], p)
    local next = string.format([[<Cmd>call search('%s','w')<CR>]], p)
    vim.keymap.set({ 'n' }, '[r', prev, { silent = true, buffer = true, desc = '[base] Goto prev region' })
    vim.keymap.set({ 'n' }, ']r', next, { silent = true, buffer = true, desc = '[base] Goto next region' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = '[Clojure] add keymaps for Goto prev/next (comment)',
  pattern = { 'clojure', 'janet' },
  callback = function()
    local p = [[\v(^\(comment|^#_)]]
    local prev = string.format([[<Cmd>call search('%s','bw')<CR>]], p)
    local next = string.format([[<Cmd>call search('%s','w')<CR>]], p)
    vim.keymap.set({ 'n' }, '[C', prev, { silent = true, buffer = true, desc = '[base] Clojure goto prev comment' })
    vim.keymap.set({ 'n' }, ']C', next, { silent = true, buffer = true, desc = '[base] Clojure goto next comment' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = '[Just] add keymaps for Goto prev/next task',
  pattern = { 'just' },
  callback = function()
    local p = [[\v^\w+.*:$]]
    local prev = string.format([[<Cmd>call search('%s','bw')<CR>]], p)
    local next = string.format([[<Cmd>call search('%s','w')<CR>]], p)
    vim.keymap.set({ 'n' }, '[e', prev, { silent = true, buffer = true, desc = '[base] Justfile goto prev task' })
    vim.keymap.set({ 'n' }, ']e', next, { silent = true, buffer = true, desc = '[base] Justfile goto next task' })
  end,
})
