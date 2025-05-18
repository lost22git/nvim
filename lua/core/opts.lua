-- [nfnl] fnl/core/opts.fnl
vim.o.termguicolors = true
vim.o.background = "light"
if not vim.g.neovide then
  vim.o.guifont = "IosevkaTermSlab NFM:h14"
  vim.o.guifontwide = "Maple Mono SC NF:h14"
else
end
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.infercase = true
vim.o.wildignorecase = true
vim.o.showcmd = true
vim.o.cmdheight = 1
vim.o.completeopt = "menu,menuone,noselect,noinsert,preview"
vim.opt.guicursor:append("t-c:ver25")
vim.o.cursorcolumn = false
vim.o.cursorline = false
vim.o.cursorlineopt = "line,number"
vim.scriptencoding = "utf-8"
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.winborder = "rounded"
vim.o.winblend = 0
vim.o.pumblend = 0
vim.opt.fillchars:append({eob = " ", foldsep = " ", foldopen = "\239\145\188", foldclose = "\239\145\160"})
vim.o.foldcolumn = "1"
vim.o.foldenable = true
vim.o.foldlevelstart = 99
vim.o.foldlevel = 99
vim.o.foldmethod = "indent"
vim.o.breakindent = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.shiftwidth = 2
vim.o.number = true
vim.o.relativenumber = false
vim.o.numberwidth = 2
vim.o.showmode = false
vim.o.mouse = "a"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.signcolumn = "yes"
vim.o.laststatus = 3
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.smoothscroll = true
vim.o.scrolloff = 10
vim.o.sidescrolloff = 10
vim.o.hlsearch = true
vim.o.magic = true
vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.path:append({"**"})
vim.opt.wildignore:append({"*/node_modules/*"})
vim.o.list = true
vim.o.wrap = false
vim.o.backup = false
vim.o.swapfile = false
vim.o.undofile = false
vim.o.hidden = true
vim.o.ruler = false
vim.o.history = 2000
vim.o.virtualedit = "block"
vim.o.inccommand = "split"
vim.o.timeout = true
vim.o.ttimeout = true
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 20
vim.o.updatetime = 500
return nil
