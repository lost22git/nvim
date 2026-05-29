(set vim.opt.background :dark)
(set vim.opt.termguicolors true)

;; Case
(set vim.opt.ignorecase true)
(set vim.opt.smartcase true)

;; Cmdline
(set vim.opt.cmdheight 1)
(set vim.opt.showcmd true)
(set vim.opt.inccommand "split")

;; Completion
(set vim.opt.autocomplete true)
(set vim.opt.completeopt "fuzzy,menu,menuone,noselect,noinsert,popup")

;; Cursor
(vim.opt.guicursor:append ["n-v-sm:block-Cursor" "i-ci-ve-t-c:ver25-lCursor"])
(set vim.opt.cursorcolumn false)
(set vim.opt.cursorline true)
(set vim.opt.cursorlineopt "line,number")

;; Popup Menu / Floating Window
(set vim.opt.pumblend 0)
(set vim.opt.pumborder :single)
(set vim.opt.winblend 0)
(set vim.opt.winborder :single)

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
(set vim.opt.shiftwidth 2)
(set vim.opt.tabstop 2)
(set vim.opt.smartindent true)
(set vim.opt.smarttab true)
(set vim.opt.breakindent true)
(set vim.opt.expandtab true)

;; Line Number
(set vim.opt.number true)
(set vim.opt.numberwidth 1)
(set vim.opt.relativenumber true)

;; List
(set vim.opt.list false)
(set vim.opt.listchars {:space "·"
                        :tab "→ "
                        :trail "·"
                        :extends ">"
                        :precedes "<"})

;; Mode
(set vim.opt.showmode false)

;; Split
(set vim.opt.splitright true)
(set vim.opt.splitbelow true)

;; Status Column
(set vim.opt.signcolumn "yes")

;; Status Line
(set vim.opt.laststatus 0)

;; Scroll
(set vim.opt.smoothscroll true)
(set vim.opt.scrolloff 99)
(set vim.opt.sidescrolloff 9)

;; Search
(set vim.opt.hlsearch true)
(set vim.opt.grepformat "%f:%l:%c:%m")
(set vim.opt.grepprg "rg --vimgrep --no-heading --smart-case")

;; Misc
(set vim.opt.backup false)
(set vim.opt.swapfile false)
(set vim.opt.timeout true)
(set vim.opt.ttimeout true)
(set vim.opt.timeoutlen 500)
(set vim.opt.ttimeoutlen 20)
(set vim.opt.undofile true)
(set vim.opt.updatetime 500)
(set vim.opt.virtualedit "block")
(set vim.opt.wrap false)

;; UI2
((. (require :vim._core.ui2) :enable) {:enable true :msg {:target :cmd}})
