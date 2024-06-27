-- set file format to unix
vim.cmd [[ autocmd BufNewFile,BufRead * set ff=unix ]]

-- filetype register
vim.cmd [[au BufNewFile,BufRead *.v set filetype=vlang]]
vim.cmd [[au BufNewFile,BufRead *.postcss set filetype=postcss]]
vim.cmd [[au BufNewFile,BufRead *.nu set filetype=nu]]
vim.cmd [[au BufNewFile,BufRead *.cy set filetype=cyber]]

-- set commentstring for filetype
vim.cmd [[
  autocmd FileType nim setlocal commentstring=#\ %s
  autocmd FileType crystal setlocal commentstring=#\ %s
  autocmd FileType inko setlocal commentstring=#\ %s
  autocmd FileType cyber setlocal commentstring=--\ %s
]]


-- restore terminal cursor shape when leaving
-- \x1b[?12l -> disable cursor blink
vim.cmd [[
  autocmd VimLeave * set guicursor= | call chansend(v:stderr, "\x1b[ q \x1b[?12l")
]]


-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = '*',
  command = "set nopaste"
})
