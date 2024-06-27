-- require('impatient').enable_profile()
-- require('impatient')


require('core.opts')
require('core.autocmd')
require('core.shells')

--#region 加载插件

require("lz")
-- require("plugin")
--#endregion 加载插件

require('core.maps')
require('core.hls')

--#region 加载 neovide 配置
local U = require('core.utils')
if U.is_neovide() then
  require('neovide')
end
--#endregion 加载 neovide 配置

--#region 加载 fvim 配置
if U.is_fvim() then
  require('fvim')
end
--#endregion 加载 fvim 配置
