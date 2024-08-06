-- set file format to unix
vim.cmd [[ au BufNewFile,BufReadPost * set fileformat=unix ]]

-- filetype register
vim.cmd [[
  au BufNewFile,BufReadPost *.v set filetype=vlang
  au BufNewFile,BufReadPost *.postcss set filetype=postcss
  au BufNewFile,BufReadPost *.nu set filetype=nu
  au BufNewFile,BufReadPost *.cy set filetype=cyber
]]

-- set commentstring for filetype
vim.cmd [[
  au FileType nim setlocal commentstring=#\ %s
  au FileType crystal setlocal commentstring=#\ %s
  au FileType inko setlocal commentstring=#\ %s
  au FileType cyber setlocal commentstring=--\ %s
  au FileType just setlocal commentstring=#\ %s
]]


-- restore terminal cursor shape when leaving
-- \x1b[?12l -> disable cursor blink
vim.cmd [[ au VimLeave * set guicursor= | call chansend(v:stderr, "\x1b[ q \x1b[?12l") ]]


-- Turn off paste mode when leaving insert
vim.cmd [[ au InsertLeave * set nopaste ]]
