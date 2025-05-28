-- [nfnl] fnl/core/opts.fnl
vim.opt.background = "light"
vim.opt.termguicolors = true
if not vim.g.neovide then
  vim.opt.guifont = "IosevkaTermSlab NFM:h14"
  vim.opt.guifontwide = "Maple Mono SC NF:h14"
else
end
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.completeopt = "menu,menuone,noselect,noinsert,preview"
vim.opt.guicursor:append("t-c:ver25")
vim.opt.cursorcolumn = false
vim.opt.cursorline = true
vim.opt.cursorlineopt = "line,number"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.winborder = "rounded"
vim.opt.winblend = 0
vim.opt.pumblend = 0
vim.opt.fillchars:append({eob = " ", foldsep = " ", foldopen = "\239\145\188", foldclose = "\239\145\160"})
vim.opt.foldcolumn = "1"
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99
vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.numberwidth = 1
vim.opt.relativenumber = false
vim.opt.showmode = false
vim.opt.mouse = "a"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 0
vim.opt.statusline = "%{repeat('\226\148\128',winwidth('.'))}"
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smoothscroll = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.hlsearch = true
vim.opt.magic = true
vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.path:append({"**"})
vim.opt.wildignore:append({"*/node_modules/*"})
vim.opt.backup = false
vim.opt.inccommand = "split"
vim.opt.list = false
vim.opt.swapfile = false
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 20
vim.opt.undofile = true
vim.opt.updatetime = 500
vim.opt.virtualedit = "block"
vim.opt.wrap = false
return nil
