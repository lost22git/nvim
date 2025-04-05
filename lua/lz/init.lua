-- bootstrap from github
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- load lazy
require('lazy').setup('lz.plugins', {
  -- debug = true,
  defaults = { lazy = true },
  lockfile = vim.fn.stdpath('config') .. '/lazy-lock.json',
  git = {
    -- defaults for the `Lazy log` command
    -- log = { "-10" }, -- show the last 10 commits
    log = { '--since=3 days ago' }, -- show commits from the last 3 days
    timeout = 120, -- kill processes that take more than 2 minutes
    url_format = 'https://github.com/%s.git',
  },
  ui = {
    size = { width = 0.8, height = 0.8 },
    border = vim.opt.winborder:get(),
  },
  performance = {
    reset_packpath = true, -- reset the package path to improve startup time
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
        'spellfile',
      },
    },
  },
})

vim.keymap.set({ '', 'i' }, '<M-0>', '<Cmd>Lazy<CR>', { silent = true, noremap = true, desc = 'Lazy' })

-- UserCommand - Plugins
vim.api.nvim_create_user_command('Plugins', function()
  local config_path = vim.fn.stdpath('config')
  local shell = vim.fn.has('win32') == 1
      and string.format(
        [[rg -g '*.lua' -U "\{\s+'([\w\._-]+?/[\w\._-]+?)'" %q -INor '$1' | rg '\.c$' -v | sort -uniq]],
        config_path
      )
    or string.format(
      [[rg -g '*.lua' -U "\{\s+'([\w\._-]+?/[\w\._-]+?)'" %q -INor '$1' | rg '\.c$' -v | sort | uniq]],
      config_path
    )
  local cmd = vim.fn.has('win32') == 1 and { 'powershell', '-nologo', '-noprofile', '-command', shell }
    or { 'sh', '-c', shell }

  vim.system(cmd, { text = true }, function(result)
    vim.print('; === Plugins ===')
    -- vim.print(shell)
    vim.print(result.stdout)
    vim.print('')
  end)
end, {})
