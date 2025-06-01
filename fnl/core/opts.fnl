(set vim.opt.background :light)
(set vim.opt.termguicolors true)

;; GUI Font
;; Neovide respect it's config.toml which supports light style
;; As for others, use this
(when (not vim.g.neovide)
  (set vim.opt.guifont "IosevkaTermSlab NFM:h14")
  (set vim.opt.guifontwide "Maple Mono SC NF:h14"))

;; Case
(set vim.opt.ignorecase true)
(set vim.opt.infercase true)
(set vim.opt.smartcase true)
(set vim.opt.wildignorecase true)

;; Cmdline
(set vim.opt.showcmd true)
(set vim.opt.cmdheight 1)

;; Column Limitation
; (set vim.opt.colorcolumn "80")
; (set vim.opt.textwidth 100)

;; Completion
(set vim.opt.completeopt "menu,menuone,noselect,noinsert,preview")

;; Cursor
(vim.opt.guicursor:append "t-c:ver25")
(set vim.opt.cursorcolumn false)
(set vim.opt.cursorline true)
(set vim.opt.cursorlineopt "line,number")

;; Encoding
(set vim.opt.encoding "utf-8")
(set vim.opt.fileencoding "utf-8")

;; Floating Window / Popup Menu
(set vim.opt.winborder "rounded")
(set vim.opt.winblend 0)
(set vim.opt.pumblend 0)

;; Fold
(vim.opt.fillchars:append {:eob " "
                           :foldsep " "
                           :foldopen ""
                           :foldclose ""})

(set vim.opt.foldcolumn "1")
(set vim.opt.foldenable true)
(set vim.opt.foldlevelstart 99)
(set vim.opt.foldlevel 99)
(set vim.opt.foldmethod "indent")

;; Indentation
(set vim.opt.autoindent true)
(set vim.opt.breakindent true)
(set vim.opt.shiftwidth 2)
(set vim.opt.smartindent true)

;; Line Number
(set vim.opt.number true)
(set vim.opt.numberwidth 1)
(set vim.opt.relativenumber false)

;; Mode
(set vim.opt.showmode false)

;; Mouse 
(set vim.opt.mouse "a")

;; Split
(set vim.opt.splitright true)
(set vim.opt.splitbelow true)

;; Status Column
(set vim.opt.signcolumn "yes")

;; Status Line
(set vim.opt.laststatus 3)
(when (not vim.g.zz.statusline)
  (set vim.opt.laststatus 0)
  (set vim.opt.statusline "%{repeat('─',winwidth('.'))}"))

;; <Tab> key
(set vim.opt.tabstop 2)
(set vim.opt.expandtab true)
(set vim.opt.smarttab true)

;; Scroll
(set vim.opt.smoothscroll true)
(set vim.opt.scrolloff 10)
(set vim.opt.sidescrolloff 10)

;; Search
(set vim.opt.hlsearch true)
(set vim.opt.magic true)
(set vim.opt.grepformat "%f:%l:%c:%m")
(set vim.opt.grepprg "rg --vimgrep --no-heading --smart-case")

;; Misc
(set vim.opt.backup false)
(set vim.opt.inccommand "split")
(set vim.opt.list false)
(set vim.opt.swapfile false)
(set vim.opt.timeout true)
(set vim.opt.ttimeout true)
(set vim.opt.timeoutlen 500)
(set vim.opt.ttimeoutlen 20)
(set vim.opt.undofile true)
(set vim.opt.updatetime 500)
(set vim.opt.virtualedit "block")
(set vim.opt.wrap false)
