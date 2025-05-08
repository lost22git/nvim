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
  au BufNewFile,BufReadPost *.lfe set filetype=lfe
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
  au FileType lfe setlocal commentstring=;\ %s
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

local nvim_help = function()
  local U = require('core.utils')
  local q = U.on_v_modes() and U.get_current_selection_text() or vim.fn.expand('<cword>')
  vim.cmd('help ' .. q)
end
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Add keymaps for nvim help',
  pattern = { 'lua' },
  callback = function(ev)
    local cb = function() vim.keymap.set({ 'n', 'v' }, '<Leader>k', nvim_help, { buffer = ev.buf, desc = 'nvim help' }) end
    vim.defer_fn(cb, 1000)
  end,
})

local add_keymaps_for_docr = function(_) end
local docr = function(subcmd)
  local open_doc_window = function(obj, title)
    print('')
    local text = vim.fn.trim(assert(obj.stdout))
    require('core.utils').open_hover_window(text, title, function(buf, _)
      vim.bo[buf].filetype = 'markdown'
      add_keymaps_for_docr(buf)
    end)
  end

  local U = require('core.utils')
  local q = U.on_v_modes() and U.get_current_selection_text() or vim.fn.expand('<cword>')

  local cmd = { 'docr', subcmd, "'" .. vim.fn.escape(q, "'") .. "'" }
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
add_keymaps_for_docr = function(buf)
  vim.keymap.set({ 'n', 'v' }, '<Leader>k', function() docr('info') end, { buffer = buf, desc = 'docr info' })
  vim.keymap.set({ 'n', 'v' }, '<Leader>K', function() docr('search') end, { buffer = buf, desc = 'docr search' })
  vim.keymap.set({ 'n', 'v' }, '<Leader>kk', function() docr('tree') end, { buffer = buf, desc = 'docr tree' })
end
vim.api.nvim_create_autocmd('FileType', {
  desc = '[Crystal] add keymaps for docr',
  pattern = 'crystal',
  callback = function(ev) add_keymaps_for_docr(ev.buf) end,
})

local lfe_doc = function(m_or_h)
  local open_doc_window = function(obj, title)
    print('')
    local text = vim.fn.trim(assert(obj.stdout))
    require('core.utils').open_hover_window(text, title, function(buf, _) vim.bo[buf].filetype = 'markdown' end)
  end

  local U = require('core.utils')
  local q = U.on_v_modes() and U.get_current_selection_text() or vim.fn.expand('<cword>')

  local qq = ''
  if m_or_h == 'm' then
    qq = "(m '" .. q .. ')' -- (m 'proc_ib)
  else
    -- q='proc_lib' => qq="(h 'proc_lib)"
    -- q='proc_lib:stop' => qq="(h 'proc_lib 'stop)"
    -- q='proc_lib:stop/3' => qq="(h 'proc_lib 'stop 3)"
    local m, fa = unpack(vim.split(q, ':'))
    local f, a = nil, nil
    if fa then
      f, a = unpack(vim.split(fa, '/'))
    end
    qq = '(h'
    qq = qq .. (m and " '" .. m or '')
    qq = qq .. (f and " '" .. f or '')
    qq = qq .. (a and ' ' .. a or '')
    qq = qq .. ')'
    print(qq)
  end

  local cmd = { 'lfe', '-e', qq }
  local cmd_str = table.concat(cmd, ' ')
  print(cmd_str, ' ...')

  vim.system(cmd, { text = true, stdin = string.rep('y\n', 10) }, function(res)
    if res.code ~= 0 or res.stdout == nil or res.stdout == '' then
      vim.print(cmd_str, res)
      return
    end
    vim.schedule_wrap(open_doc_window)(res, cmd_str)
  end)
end
vim.api.nvim_create_autocmd('FileType', {
  desc = '[LFE] add keymaps for (m mode) or (h mod fun arity)',
  pattern = 'lfe',
  callback = function(ev)
    vim.keymap.set(
      { 'n', 'v' },
      '<Leader>k',
      function() lfe_doc('h') end,
      { buffer = ev.buf, desc = 'lfe (h mod fun arity)' }
    )
    vim.keymap.set({ 'n', 'v' }, '<Leader>K', function() lfe_doc('m') end, { buffer = ev.buf, desc = 'lfe (m mod)' })
  end,
})
