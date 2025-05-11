local o = vim.opt

o.termguicolors = true
o.background = 'light'

-- GUI Font
-- Neovide respect it's config.toml which supports light style
-- Others use this
if not vim.g.neovide then
  o.guifont = [[IosevkaTermSlab NFM:h14]]
  o.guifontwide = [[Maple Mono SC NF:h14]]
end

-- Case
o.ignorecase = true
o.smartcase = true
o.infercase = true
o.wildignorecase = true

-- Cmdline
o.showcmd = true
o.cmdheight = 1

-- Column Limitation
-- o.colorcolumn = '80'
-- o.textwidth = 100

-- Completion
o.completeopt = 'menu,menuone,noselect,noinsert,preview'

-- Cursor
o.guicursor:append('t-c:ver25') -- use bar style (ver25) on terminal and cmd mode
o.cursorcolumn = false
o.cursorline = false
o.cursorlineopt = 'line,number'

-- Encoding
vim.scriptencoding = 'utf-8'
o.encoding = 'utf-8'
o.fileencoding = 'utf-8'

-- Floating Window / Popup Menu
o.winborder = 'rounded'
o.winblend = 0
o.pumblend = 0

-- Fold
o.fillchars:append({
  eob = ' ',
  foldsep = ' ',
  foldopen = '',
  foldclose = '',
})
o.foldcolumn = '1'
o.foldenable = true
o.foldlevelstart = 99
o.foldlevel = 99
o.foldmethod = 'indent'

-- Indentation
o.breakindent = true
o.autoindent = true
o.smartindent = true
o.shiftwidth = 2

-- Line Number
o.number = true
o.relativenumber = false
o.numberwidth = 2

-- Mode
o.showmode = false

-- Mouse Support
o.mouse = 'a'

-- Split
o.splitright = true
o.splitbelow = true

-- Status Column
o.signcolumn = 'yes'

-- Status Line
o.laststatus = 3

-- <Tab> key
o.tabstop = 2 -- <tab> spacecount
o.expandtab = true
o.smarttab = true

-- Scroll
o.smoothscroll = true
o.scrolloff = 10
-- o.scrolloff = (999 - vim.o.scrolloff) -- keep cursor centered
o.sidescrolloff = 10

-- Search
o.hlsearch = true
o.magic = true

-- Misc
o.list = true
o.wrap = false
o.backup = false
o.swapfile = false
o.undofile = false
o.hidden = true
o.ruler = false
o.history = 2000
o.virtualedit = 'block'
o.inccommand = 'split'
o.timeout = true
o.ttimeout = true
o.timeoutlen = 500
o.ttimeoutlen = 20
o.updatetime = 500

-- Finding files - Search down into subfolders
o.path:append({ '**' })
o.wildignore:append({ '*/node_modules/*' })

-- Replace `vimgrep` with `ripgrep`
o.grepformat = [[%f:%l:%c:%m,%f:%l:%m]]
o.grepprg = [[rg --vimgrep --no-heading --smart-case]]
