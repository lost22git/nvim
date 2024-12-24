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
  install = {
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    -- colorscheme = { "habamax" },
  },
  checker = {
    enabled = false,
    concurrency = nil, ---@type number? set to 1 to check for updates very slowly
    notify = true, -- get a notification when new updates are found
    frequency = 3600, -- check for updates every hour
  },
  change_detection = {
    enabled = true,
    notify = true,
  },
  ui = {
    size = { width = 0.8, height = 0.8 },
    border = 'single',
    icons = {
      cmd = ' ',
      config = '',
      event = '',
      ft = ' ',
      init = ' ',
      keys = ' ',
      plugin = ' ',
      runtime = ' ',
      source = ' ',
      start = '',
      task = '✔ ',
    },
    throttle = 20, -- how frequently should the ui process render events
  },
  performance = {
    -- cache = {
    --   enabled = true,
    --   path = vim.fn.stdpath("state") .. "/lazy/cache",
    --   -- Once one of the following events triggers, caching will be disabled.
    --   -- To cache all modules, set this to `{}`, but that is not recommended.
    --   -- The default is to disable on:
    --   --  * VimEnter: not useful to cache anything else beyond startup
    --   --  * BufReadPre: this will be triggered early when opening a file from the command line directly
    --   disable_events = { "VimEnter", "BufReadPre" },
    -- },
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

vim.keymap.set({ '', 'i' }, '<M-0>', '<cmd>Lazy<CR>', { silent = true, noremap = true })
