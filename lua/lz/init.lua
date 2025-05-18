-- [nfnl] fnl/lz/init.fnl
local lazypath = (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
else
end
vim.opt.runtimepath:prepend(lazypath)
local lazy = require("lazy")
return lazy.setup("lz.plugins", {defaults = {lazy = true}, lockfile = (vim.fn.stdpath("config") .. "/lazy-lock.json"), git = {log = {"--since=3 days ago"}, timeout = 120, url_format = "https://github.com/%s.git"}, ui = {size = {width = 0.8, height = 0.8}, border = vim.o.winborder, backdrop = vim.g.zz.backdrop}, performance = {reset_packpath = true, rtp = {disabled_plugins = {"gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin", "spellfile"}}}})
