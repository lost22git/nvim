-- require('impatient').enable_profile()
-- require('impatient')

require('core.opts')
require('core.autocmds')

-- 加载插件
require("lz")

require('core.maps')
require('core.hls')

-- 加载 GUI 配置
local U = require('core.utils')
if U.is_neovide() then
  -- 加载 neovide 配置
  require('neovide')
elseif U.is_fvim() then
  -- 加载 fvim 配置
  require('fvim')
end
