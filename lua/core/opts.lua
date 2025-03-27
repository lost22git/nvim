vim.opt.termguicolors = true
vim.opt.background = 'light'

-- GUI Font
-- Neovide respect it's config.toml which supports light style
-- Others use this
if not vim.g.neovide then
  vim.opt.guifont = [[IosevkaTermSlab NFM:h14]]
  vim.opt.guifontwide = [[Maple Mono SC NF:h14]]
end

-- Encoding
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- Mouse Support
vim.opt.mouse = 'a'

-- Status Line
vim.opt.laststatus = 3

-- Cursor
vim.opt.guicursor:append('c:ver25') -- use bar style (ver25) on cmd mode
vim.opt.cursorcolumn = false
vim.opt.cursorline = false
vim.opt.cursorlineopt = 'line,number'

-- Floating Window / Popup Menu
vim.opt.winborder = 'rounded'
vim.opt.winblend = 0 -- floating window transparency [0-100]
vim.opt.pumblend = 0 -- popup menu transparency [0-100]

-- Line Number
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.numberwidth = 2

-- Sign Column
vim.opt.signcolumn = 'yes' -- always render signcolumn to avoid jitter

-- Column Limitation
vim.opt.colorcolumn = '80'
-- vim.opt.textwidth = 100

-- Visable Area Scroll Range
vim.opt.scrolloff = 10 -- scroll offset lines
vim.opt.wrap = false
vim.opt.sidescrolloff = 10 -- scroll offset columns (works with wrap=false)
-- vim.opt.scrolloff = (999 - vim.o.scrolloff) -- keep cursor centered

-- Split
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Indentation
vim.opt.breakindent = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 2

-- <Tab> key
vim.opt.tabstop = 2 -- <tab> spacecount
vim.opt.expandtab = true
vim.opt.smarttab = true

-- Cmdline
vim.opt.showcmd = true
vim.opt.cmdheight = 1

-- Case
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true
vim.opt.wildignorecase = true

-- Search
vim.opt.hlsearch = true
vim.opt.magic = true

-- Completion
vim.opt.completeopt = 'menu,menuone,noselect,noinsert,preview'

-- Misc
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.hidden = true
vim.opt.ruler = false
vim.opt.history = 2000
vim.opt.virtualedit = 'block'
vim.opt.inccommand = 'split'
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 20
vim.opt.updatetime = 500

-- Finding files - Search down into subfolders
vim.opt.path:append({ '**' })
vim.opt.wildignore:append({ '*/node_modules/*' })

-- Replace `vimgrep` with `ripgrep`
vim.opt.grepformat = [[%f:%l:%c:%m,%f:%l:%m]]
vim.opt.grepprg = [[rg --vimgrep --no-heading --smart-case]]
