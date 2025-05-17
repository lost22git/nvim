local g = vim.g

local zz_default = {
  transparent = false,
  shell = vim.fn.has('win32') == 1 and 'pwsh',
  backdrop = 100,
}
g.zz = vim.tbl_deep_extend('force', zz_default, g.zz or {})

g.mapleader = ' '
g.maplocalleader = ' '

g.markdown_fenced_languages = { 'ts=typescript' }
g.markdown_recommended_style = 0

-- :help clipboard
-- see https://github.com/neovim/neovim/issues/9570
if vim.fn.has('win32') == 1 then
  g.clipboard = {
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
elseif vim.fn.has('wsl') == 1 then
  g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = '/mnt/c/Windows/System32/clip.exe',
      ['*'] = '/mnt/c/Windows/System32/clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -nologo -noprofile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -nologo -noprofile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
else
end
