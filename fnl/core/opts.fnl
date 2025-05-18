(set vim.o.termguicolors true)
(set vim.o.background "light")

;; GUI Font
;; Neovide respect it's config.toml which supports light style
;; As for others, use this
(when (not vim.g.neovide)
  (set vim.o.guifont "IosevkaTermSlab NFM:h14")
  (set vim.o.guifontwide "Maple Mono SC NF:h14"))

;; Case
(set vim.o.ignorecase true)
(set vim.o.smartcase true)
(set vim.o.infercase true)
(set vim.o.wildignorecase true)

;; Cmdline
(set vim.o.showcmd true)
(set vim.o.cmdheight 1)

;; Column Limitation
; (set vim.o.colorcolumn "80")
; (set vim.o.textwidth 100)

;; Completion
(set vim.o.completeopt "menu,menuone,noselect,noinsert,preview")

;; Cursor
(vim.opt.guicursor:append "t-c:ver25")
(set vim.o.cursorcolumn false)
(set vim.o.cursorline false)
(set vim.o.cursorlineopt "line,number")

;; Encoding
(set vim.scriptencoding "utf-8")
(set vim.o.encoding "utf-8")
(set vim.o.fileencoding "utf-8")

;; Floating Window / Popup Menu
(set vim.o.winborder "rounded")
(set vim.o.winblend 0)
(set vim.o.pumblend 0)

;; Fold
(vim.opt.fillchars:append {:eob " "
                           :foldsep " "
                           :foldopen ""
                           :foldclose ""})

(set vim.o.foldcolumn "1")
(set vim.o.foldenable true)
(set vim.o.foldlevelstart 99)
(set vim.o.foldlevel 99)
(set vim.o.foldmethod "indent")

;; Indentation
(set vim.o.breakindent true)
(set vim.o.autoindent true)
(set vim.o.smartindent true)
(set vim.o.shiftwidth 2)

;; Line Number
(set vim.o.number true)
(set vim.o.relativenumber false)
(set vim.o.numberwidth 2)

;; Mode
(set vim.o.showmode false)

;; Mouse Support
(set vim.o.mouse "a")

;; Split
(set vim.o.splitright true)
(set vim.o.splitbelow true)

;; Status Column
(set vim.o.signcolumn "yes")

;; Status Line
(set vim.o.laststatus 3)

;; <Tab> key
(set vim.o.tabstop 2)
(set vim.o.expandtab true)
(set vim.o.smarttab true)

;; Scroll
(set vim.o.smoothscroll true)
(set vim.o.scrolloff 10)
(set vim.o.sidescrolloff 10)

;; Search
(set vim.o.hlsearch true)
(set vim.o.magic true)
(set vim.o.grepformat "%f:%l:%c:%m,%f:%l:%m")
(set vim.o.grepprg "rg --vimgrep --no-heading --smart-case")
(vim.opt.path:append ["**"])
(vim.opt.wildignore:append ["*/node_modules/*"])

;; Misc
(set vim.o.list true)
(set vim.o.wrap false)
(set vim.o.backup false)
(set vim.o.swapfile false)
(set vim.o.undofile false)
(set vim.o.hidden true)
(set vim.o.ruler false)
(set vim.o.history 2000)
(set vim.o.virtualedit "block")
(set vim.o.inccommand "split")
(set vim.o.timeout true)
(set vim.o.ttimeout true)
(set vim.o.timeoutlen 500)
(set vim.o.ttimeoutlen 20)
(set vim.o.updatetime 500)
