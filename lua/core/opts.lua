-- [nfnl] fnl/core/opts.fnl
vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cmdheight = 1
vim.opt.showcmd = true
vim.opt.inccommand = "split"
vim.opt.autocomplete = true
vim.opt.completeopt = "fuzzy,menu,menuone,noselect,noinsert,popup"
vim.opt.guicursor:append({"n-v-sm:block-Cursor", "i-ci-ve-t-c:ver25-lCursor"})
vim.opt.cursorcolumn = false
vim.opt.cursorline = true
vim.opt.cursorlineopt = "line,number"
vim.opt.pumblend = 0
vim.opt.pumborder = "single"
vim.opt.winblend = 0
vim.opt.winborder = "single"
vim.opt.fillchars:append({eob = " ", foldsep = " ", foldopen = "\239\145\188", foldclose = "\239\145\160"})
vim.opt.foldcolumn = "1"
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99
vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.numberwidth = 1
vim.opt.relativenumber = true
vim.opt.list = false
vim.opt.listchars = {space = "\194\183", tab = "\226\134\146 ", trail = "\194\183", extends = ">", precedes = "<"}
vim.opt.showmode = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 0
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smoothscroll = true
vim.opt.scrolloff = 99
vim.opt.sidescrolloff = 9
vim.opt.hlsearch = true
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 20
vim.opt.undofile = true
vim.opt.updatetime = 500
vim.opt.virtualedit = "block"
vim.opt.wrap = false
return require("vim._core.ui2").enable({enable = true, msg = {target = "cmd"}})
