local plugin = require('plugin.pack').register_plugin
local conf = require('plugin.mod.theme.config')

-- plugin{
--     'folke/tokyonight.nvim',
--     config = conf.tokyonight,
-- }

-- plugin{
--   'projekt0n/github-nvim-theme',
--   config = conf.github,
-- }

plugin {
  'Mofiqul/vscode.nvim',
  config = conf.vscode,
}
