require('core.vars')
require('core.opts')
require('core.autocmds')

-- load plugins
require('lz')

-- after plugins to override them
require('core.maps')
require('core.hls')

-- load GUI
if vim.g.neovide then
  require('neovide')
elseif vim.g.fvim_loaded then
  require('fvim')
end
