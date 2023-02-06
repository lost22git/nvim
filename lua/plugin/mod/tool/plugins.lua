local plugin = require('plugin.pack').register_plugin
local conf = require('plugin.mod.tool.config')

plugin {
  "dstein64/vim-startuptime",
  cmd = "StartupTime",
  config = function()
    vim.g.startuptime_tries = 10
  end,
}

--
-- plugin{
--   "nathom/filetype.nvim",
--   module={"vim.filetype"},
--   config = function()
--     require('filetype').setup{}
--   end,
-- }


-- 先输出 `j`，如果后序为 `k` 则删除 `j` 并 `<Esc>`
-- 避免 vim 默认需要等待超时才输出 `j`
-- 这样就只有需要同时输出 `jk` 这一种情况才需要等待
plugin {
  'TheBlob42/houdini.nvim',
  event = { "InsertEnter", "CmdLineEnter", "TermEnter" },
  config = function()
    require('houdini').setup()
  end
}

plugin {
  "folke/trouble.nvim",
  cmd = { 'Trouble' },
  keys = { '<M-9>', '<leader>xx', '<Leader>xd', '<Leader>xr' },
  config = conf.trouble,
}

plugin {
  'numToStr/Comment.nvim',
  keys = { 'gcc', 'gc' },
  config = function()
    require('Comment').setup()
  end
}

plugin {
  'lukas-reineke/indent-blankline.nvim',
  event = { "BufReadPost", "BufNewFile" },
  -- event = 'VeryLazy',
  config = conf.indent_blankline,
}

plugin {
  'norcalli/nvim-colorizer.lua',
  cmd = { "ColorizerAttachToBuffer" },
}

plugin {
  "folke/zen-mode.nvim",
  module = "zen-mode",
  cmd = { "ZenMode" },
}

plugin {
  "woosaaahh/sj.nvim",
  -- event  = { "BufRead" },
  event = 'VeryLazy',
  config = conf.sj,
}

plugin {
  "smjonas/inc-rename.nvim",
  cmd = "IncRename",
  config = function()
    require("inc_rename").setup {}
  end,
}

plugin {
  's1n7ax/nvim-window-picker',
  module = { 'window-picker' },
  keys = { '<Leader>w' },
  tag = 'v1.*',
  config = function()
    require 'window-picker'.setup()
    require('core.maps').window_picker()
  end,
}
