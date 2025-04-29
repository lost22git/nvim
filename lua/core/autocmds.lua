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

local docr = function(info_or_search)
  local on_v_modes = function()
    local v_block_mode = vim.api.nvim_replace_termcodes('<C-V>', true, true, true)
    local v_mode, v_line_mode = 'v', 'V'
    local v_modes = { v_mode, v_line_mode, v_block_mode }
    return vim.tbl_contains(v_modes, vim.fn.mode())
  end

  local open_doc_window = function(obj, title)
    print('')
    local text = vim.fn.trim(assert(obj.stdout))
    local lines = vim.fn.split(text, '\n', true)
    local max_cols = 0
    for _, l in ipairs(lines) do
      max_cols = math.max(max_cols, vim.api.nvim_strwidth(l))
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, #lines, false, lines)
    local win = vim.api.nvim_open_win(buf, true, {
      relative = 'cursor',
      row = 1,
      col = 0,
      width = max_cols,
      height = math.min(7, #lines),
      style = 'minimal',
      title = title,
    })
    vim.cmd('Man!')
    vim.bo[buf].filetype = 'man'
    vim.bo[buf].readonly = true
    vim.bo[buf].modifiable = false
    vim.wo[win].wrap = false
  end

  -- on visual mode: get current selection text
  -- on normal mode: get word under current cursor
  local q = on_v_modes() and require('core.utils').get_current_selection_text() or vim.fn.expand('<cword>')

  local cmd = { 'docr', info_or_search, "'" .. vim.fn.escape(q, "'") .. "'" }
  local cmd_str = table.concat(cmd, ' ')
  print(cmd_str, ' ...')

  vim.system(cmd, { text = true }, function(res)
    if res.code ~= 0 or res.stdout == nil or res.stdout == '' then
      vim.print(cmd_str, res)
      return
    end
    vim.schedule_wrap(open_doc_window)(res, cmd_str)
  end)
end
vim.api.nvim_create_autocmd('FileType', {
  desc = '[Crystal] add keymaps for docr',
  pattern = 'crystal',
  callback = function(ev)
    vim.keymap.set({ 'n', 'v' }, '<Leader>k', function() docr('info') end, { buffer = ev.buf, desc = 'docr info' })
    vim.keymap.set({ 'n', 'v' }, '<Leader>K', function() docr('search') end, { buffer = ev.buf, desc = 'docr search' })
  end,
})
