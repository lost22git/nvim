local U = require('core.utils')

local opt = vim.opt

-- gui client 字体
opt.guifont = 'SauceCodePro Nerd Font Mono:l:h14'

-- 编码
vim.scriptencoding = 'utf-8'
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

-- 鼠标支持
opt.mouse = 'a'

-- 全局共用一个状态栏
opt.laststatus = 3

-- 行号
opt.number = true
opt.relativenumber = false
opt.numberwidth = 2

-- 颜色 & 透明度
opt.termguicolors = true -- 终端使用 24-bit rgb
opt.winblend = 0         -- float window 透明度 [0-100]
opt.pumblend = 0         -- popup menu 透明度 [0-100]
opt.background = 'dark'  -- 背景色

-- 高亮
opt.cursorcolumn = false          -- 高亮当
opt.cursorline = false            -- 高亮当前行
opt.cursorlineopt = "line,number" -- 只高亮行号, 默认 "line,number" 同时高亮行号和行
-- opt.colorcolumn = '100' -- 高亮第n列
-- opt.textwidth = 100 -- 每行文本最大列数，超过自动换行

-- 最小可见区域
opt.scrolloff = 2     -- 上下最小可见行数
opt.wrap = false
opt.sidescrolloff = 4 -- 左右最小可见列数 (wrap=false 下有效)

-- 缩进
opt.breakindent = true
opt.autoindent = true
opt.smartindent = true
opt.shiftwidth = 2 -- 缩进列数

-- <tab> 字符
opt.tabstop = 2 -- <tab> 空格个数
opt.expandtab = true
opt.smarttab = true

-- list mode
-- opt.list = true
-- opt.listchars = 'tab:»·,nbsp:+,trail:·,extends:→,precedes:←'

-- 命令行
opt.showcmd = true
opt.cmdheight = 1 -- 命令行 window 高度

-- 大小写
opt.ignorecase = true
opt.smartcase = true
opt.infercase = true
opt.wildignorecase = true

-- 搜索
opt.hlsearch = true
opt.magic = true -- 默认正则表达式模式 magic, 在正则中使用模式: \m => magic, \m => nomagic, \v => very magic, \v => very nomagic

-- 补全
opt.completeopt = "menu,menuone,noselect"

-- 其他
opt.backup = false
opt.swapfile = false
opt.undofile = false
opt.hidden = true
opt.title = false
opt.ruler = false
opt.history = 2000
opt.virtualedit = 'block' -- allow virtual editing in visual block mode.
opt.inccommand = 'split'
opt.timeout = true
opt.ttimeout = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10
opt.updatetime = 100
opt.redrawtime = 1500

-- Finding files - Search down into subfolders
opt.path:append { '**' }
opt.wildignore:append { '*/node_modules/*' }

-- 在 vim grep 中使用 rg (此处使用 vim.fn.executable 会影响启动速度 TODO)
-- if vim.fn.executable('rg') == 1 then
--     opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
--     opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
-- end


-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = '*',
  command = "set nopaste"
})

-- Add asterisks in block comments
opt.formatoptions:append { 'r' }




-- 剪贴板 :help clipboard
-- 剪贴板 register 2.0 (提升启动速度)
-- see https://github.com/neovim/neovim/issues/9570
if U.is_win() then
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
elseif U.is_mac() then
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
elseif U.is_wsl() then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = '/mnt/c/Windows/System32/clip.exe',
      ['*'] = '/mnt/c/Windows/System32/clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
else
end


vim.g.mapleader = ' '
-- 不启用一些内置插件
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarplugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipplugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptplugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballplugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logipat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwplugin = 1
vim.g.loaded_netrwsettings = 1
vim.g.loaded_netrwfilehandlers = 1

-- set file format to unix
vim.cmd [[ autocmd BufNewFile,BufRead * set ff=unix ]]

-- filetype register
vim.cmd [[au BufNewFile,BufRead *.v set filetype=vlang]]
vim.cmd [[au BufNewFile,BufRead *.postcss set filetype=postcss]]
vim.cmd [[au BufNewFile,BufRead *.nu set filetype=nu]]

-- picker
vim.g.picker = 'mini.pick'
-- vim.g.picker = 'telescope'

-- theme
vim.g.transparent = false

-- vim.cmd.colorscheme 'darkblue'

if not require('core.utils').version_ge('1.9.999') then
  -- vim.g.theme = 'base16'
  vim.g.theme = 'catppuccin'
  -- vim.g.theme = 'dark_flat'
  -- vim.g.theme = 'github'
  -- vim.g.theme = 'nord'
  -- vim.g.theme = 'oxocarbon'
  -- vim.g.theme = 'vscode'
  -- vim.g.theme = 'kanagawa'
  -- vim.g.theme = 'fluoromachine'
  -- vim.g.theme = 'mellow'
  -- vim.g.theme = 'citruszest'
  -- vim.g.theme = 'night-owl'
end

-- terminal shell
if U.is_win() then
  -- local exepath = vim.fn.exepath("clink")
  -- if exepath ~= '' then
  --   exepath = string.gsub(exepath, '\\', '/') -- 替换 \ 为 /
  --   vim.g.term_shell = { 'cmd.exe', '/s', '/k', '"' .. exepath .. ' inject"' }
  -- end

  vim.g.term_shell = { 'pwsh' }
end
