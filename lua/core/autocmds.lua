-- Set file format to unix
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    if not vim.bo.modifiable then return end
    local exclude_ftypes = { 'qf', 'FTerm' }
    local ft = vim.bo.filetype
    if vim.tbl_contains(exclude_ftypes, ft) then return end
    vim.bo.fileformat = 'unix'
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'Visual',
      timeout = 200,
    })
  end,
})

-- Register filetypes
vim.cmd([[
  au BufNewFile,BufReadPost *.v set filetype=vlang
  au BufNewFile,BufReadPost *.postcss set filetype=postcss
  au BufNewFile,BufReadPost *.cy set filetype=cyber
  au BufNewFile,BufReadPost *.lobster set filetype=lobster
  au BufNewFile,BufReadPost *.c3 set filetype=c3
  au BufNewFile,BufReadPost *.kk set filetype=koka
  au BufNewFile,BufReadPost *.cljd set filetype=clojure
  au BufNewFile,BufReadPost *.bb set filetype=clojure
  au BufNewFile,BufReadPost *.http set filetype=http
]])

-- Register filetypes' commentstring
vim.cmd([[
  au FileType json setlocal commentstring=//\ %s
  au FileType nim setlocal commentstring=#\ %s
  au FileType inko setlocal commentstring=#\ %s
  au FileType cyber setlocal commentstring=--\ %s
  au FileType just setlocal commentstring=#\ %s
  au FileType gleam setlocal commentstring=//\ %s
  au FileType lobster setlocal commentstring=//\ %s
  au FileType c3 setlocal commentstring=//\ %s
  au FileType koka setlocal commentstring=//\ %s
  au FileType dart setlocal commentstring=//\ %s
  au FileType http setlocal commentstring=#\ %s
]])

-- Restore terminal cursor shape when leaving
-- \x1b[?12l -> disable cursor blink
-- \x1b[6 q -> set cursor style to bar
vim.cmd([[
  au VimLeave,VimSuspend * set guicursor= | call chansend(v:stderr, "\x1b[6 q \x1b[?12l")
  au VimResume * set guicursor=n-v-sm:block,c-i-ci-ve:ver25,r-cr-o:hor20
]])

-- Turn off paste mode when leaving insert
vim.cmd([[ au InsertLeave * set nopaste ]])

-- [clojure] Goto prev/next (comment)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'clojure' },
  callback = function()
    vim.keymap.set(
      { 'n' },
      '[C',
      [[<Cmd>call search('\(^(comment\|^#_\)','bw')<CR>]],
      { silent = true, buffer = true, desc = 'Clojure goto prev (comment) or #_' }
    )
    vim.keymap.set(
      { 'n' },
      ']C',
      [[<Cmd>call search('\(^(comment\|^#_\)','w')<CR>]],
      { silent = true, buffer = true, desc = 'Clojure goto next (comment) or #_' }
    )
  end,
})

-- Goto prev/next region
vim.api.nvim_create_autocmd('FileType', {
  pattern = { '*' },
  callback = function()
    vim.keymap.set(
      { 'n' },
      '[r',
      [[<Cmd>call search('[\/;#] === .\+ ===$','bw')<CR>]],
      { silent = true, buffer = true, desc = 'Goto prev region' }
    )
    vim.keymap.set(
      { 'n' },
      ']r',
      [[<Cmd>call search('[\/;#] === .\+ ===$','w')<CR>]],
      { silent = true, buffer = true, desc = 'Goto next region' }
    )
  end,
})

-- Justfile goto prev/next task
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'just' },
  callback = function()
    vim.keymap.set(
      { 'n' },
      '[e',
      [[<Cmd>call search('\v^\w+.*:$','bw')<CR>]],
      { silent = true, buffer = true, desc = 'Justfile goto prev task' }
    )
    vim.keymap.set(
      { 'n' },
      ']e',
      [[<Cmd>call search('\v^\w+.*:$','w')<CR>]],
      { silent = true, buffer = true, desc = 'Justfile goto next task' }
    )
  end,
})

-- Clojure start nRepl server
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'clojure' },
  callback = function()
    vim.api.nvim_buf_create_user_command(0, 'Clj', function(opts)
      local clj_opts = string.match(opts.args, '%-M:') and opts.args or (opts.args .. ' ' .. '-M')

      local deps =
        [['{:deps {nrepl/nrepl {:mvn/version "1.3.0"} refactor-nrepl/refactor-nrepl {:mvn/version "3.10.0"} cider/cider-nrepl {:mvn/version "0.52.0"} }}']]

      local cider_opts =
        [["(require 'nrepl.cmdline) (nrepl.cmdline/-main \"--interactive\" \"--middleware\" \"[ refactor-nrepl.middleware/wrap-refactor cider.nrepl/cider-middleware]\")"]]

      local command = string.format('clj -Sdeps %s %s -e %s', deps, clj_opts, cider_opts)
      local call_asyncrun = 'AsyncRun -mode=term -pos=tab -focus=0 ' .. command
      -- vim.print('call_asyncrun:', call_asyncrun)

      vim.cmd(call_asyncrun)
    end, { nargs = '*' })
  end,
})
