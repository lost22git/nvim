local LC_DEFAULT = {
  transparent = false,
  shell = vim.fn.has('win32') == 1 and 'pwsh',
}
vim.g.LC = vim.tbl_deep_extend('force', LC_DEFAULT, vim.g.LC or {})

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- :help clipboard
-- see https://github.com/neovim/neovim/issues/9570
if vim.fn.has('win32') == 1 then
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
elseif vim.fn.has('wsl') == 1 then
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
