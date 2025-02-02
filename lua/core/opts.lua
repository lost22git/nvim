local U = require('core.utils')

vim.cmd.colorscheme('default')

-----------------------------
-- custom global variables --
-----------------------------

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.transparent = vim.g.transparent or false

-- terminal shell
if U.on_win() then vim.g.term_shell = { 'pwsh' } end

-- 剪贴板 :help clipboard
-- 剪贴板 register 2.0 (提升启动速度)
-- see https://github.com/neovim/neovim/issues/9570
if U.on_win() then
  vim.g.clipboard = {
    name = 'win32yank',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
elseif U.on_mac() then
  vim.g.clipboard = {
    name = 'pbcopy',
    copy = {
      ['+'] = 'pbcopy',
      ['*'] = 'pbcopy',
    },
    paste = {
      ['+'] = 'pbpaste',
      ['*'] = 'pbpaste',
    },
    cache_enabled = 0,
  }
elseif U.on_wsl() then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = '/mnt/c/Windows/System32/clip.exe',
      ['*'] = '/mnt/c/Windows/System32/clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
else
end

-------------
-- options --
-------------

-- gui client 字体
-- neovide 使用自己的 config.toml, 因为它支持配置 light style
if not U.on_neovide() then
  vim.opt.guifont = [[IosevkaTermSlab NFM:h14]]
  vim.opt.guifontwide = [[Maple Mono SC NF:h14]]
end

-- fix default: use bar style (ver25) on cmd mode
vim.opt.guicursor = [[n-v-sm:block,c-i-ci-ve:ver25,r-cr-o:hor20]]

-- 编码
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- 鼠标支持
vim.opt.mouse = 'a'

-- 全局共用一个状态栏
vim.opt.laststatus = 3

-- 行号
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.numberwidth = 2

-- 颜色 & 透明度
vim.opt.termguicolors = true -- 终端使用 24-bit rgb
vim.opt.winblend = 0 -- float window 透明度 [0-100]
vim.opt.pumblend = 0 -- popup menu 透明度 [0-100]
vim.opt.background = 'dark' -- 背景

-- 高亮
vim.opt.cursorcolumn = true -- 高亮当前列
vim.opt.cursorline = false -- 高亮当前行
vim.opt.cursorlineopt = 'line,number' -- 只高亮行号, 默认 "line,number" 同时高亮行号和行
-- opt.colorcolumn = '100' -- 高亮第n列
-- opt.textwidth = 100 -- 每行文本最大列数，超过自动换行

-- 总是渲染 signcolumn, 避免渲染抖动
vim.opt.signcolumn = 'yes'

-- 最小可见区域
vim.opt.scrolloff = 10 -- scroll offset 上下最小可见行数
vim.opt.wrap = false
vim.opt.sidescrolloff = 10 -- scroll offset 左右最小可见列数 (wrap=false 下有效)
-- vim.opt.scrolloff = (999 - vim.o.scrolloff) -- 保持光标一直在中间

-- vsplit default right
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 缩进
vim.opt.breakindent = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 2 -- 缩进列数

-- <tab> 字符
vim.opt.tabstop = 2 -- <tab> 空格个数
vim.opt.expandtab = true
vim.opt.smarttab = true

-- list mode
-- vim.opt.list = true
-- vim.opt.listchars = 'tab:»·,nbsp:+,trail:·,extends:→,precedes:←'

-- 命令行
vim.opt.showcmd = true
vim.opt.cmdheight = 1 -- 命令行 window 高度

-- 大小写
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true
vim.opt.wildignorecase = true

-- 搜索
vim.opt.hlsearch = true
vim.opt.magic = true -- 默认正则表达式模式 magic, 在正则中使用模式: \m => magic, \m => nomagic, \v => very magic, \v => very nomagic

-- 补全
vim.opt.completeopt = [[menu,menuone,noselect]]

-- 其他
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.hidden = true
vim.opt.title = false
vim.opt.ruler = false
vim.opt.history = 2000
vim.opt.virtualedit = 'block' -- allow virtual editing in visual block mode.
vim.opt.inccommand = 'split'
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10
vim.opt.updatetime = 100
vim.opt.redrawtime = 1500

-- Finding files - Search down into subfolders
vim.opt.path:append({ '**' })
vim.opt.wildignore:append({ '*/node_modules/*' })

-- 在 vim grep 中使用 rg
vim.opt.grepformat = [[%f:%l:%c:%m,%f:%l:%m]]
vim.opt.grepprg = [[rg --vimgrep --no-heading --smart-case]]

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
vim.opt.formatoptions:append({ 'r' })
