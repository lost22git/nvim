require('core.opts')
require('core.autocmds')

-- 加载插件
require('lz')

require('core.maps')
require('core.hls')

-- 加载 GUI 配置
if vim.g.neovide then
  require('neovide')
elseif vim.g.fvim_loaded then
  require('fvim')
end
