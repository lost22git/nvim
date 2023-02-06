local plugin = require('plugin.pack').register_plugin
local conf = require('plugin.mod.ui.config')

plugin {
  'nvim-tree/nvim-web-devicons',
  module = "nvim-web-devicons",
}

plugin {
  'nvim-lualine/lualine.nvim',
  -- event = 'BufRead',
  event = 'VeryLazy',
  config = conf.lualine,
}

plugin {
  'akinsho/nvim-bufferline.lua',
  event = { 'BufAdd', 'TabEnter' },
  config = conf.bufferline,
}

plugin {
  "rcarriga/nvim-notify",
  module = "notify",
  config = conf.notify,
}

plugin {
  "folke/noice.nvim",
  keys = { "<M-0>" },
  -- event = { "BufRead", "CmdLineEnter" },
  event = 'VeryLazy',
  requires = {
    { "MunifTanjim/nui.nvim" },
  },
  config = conf.noice,
}

plugin {
  'nvim-telescope/telescope.nvim', tag = '0.1.0',
  cmd = { "Telescope" },
  keys = { "<Leader>ff", "<Leader>fg", "<Leader>fm", "<Leader>fb", "<Leader>fp", "<Leader>ft" },
  requires = {
    {
      'nvim-lua/plenary.nvim',
    },
  },
  config = conf.telescope,
}

plugin {
  'nvim-telescope/telescope-fzf-native.nvim',
  run    = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
  after  = "telescope.nvim",
  config = conf.telescope_fzf,
}

plugin {
  'nvim-telescope/telescope-file-browser.nvim',
  after = "telescope.nvim",
  config = conf.telescope_file_browser,
}

plugin {
  'numToStr/FTerm.nvim',
  keys = { '<M-3>', '<M-4>' },
  config = conf.fterm,
}

plugin {
  'theblob42/drex.nvim',
  keys = { "<M-1>" },
  config = conf.drex,
}

-- plugin {
--   "nvim-neo-tree/neo-tree.nvim",
--   cmd = { "Neotree" },
--   keys = { "<M-1>", "<M-2>" },
--   branch = "v2.x",
--   requires = {
--     "nvim-lua/plenary.nvim",
--     "nvim-tree/nvim-web-devicons",
--     "MunifTanjim/nui.nvim",
--   },
--   config = conf.neotree,
-- }
