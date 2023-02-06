local plugin = require('plugin.pack').register_plugin
local conf = require('plugin.mod.cmp.config')

plugin {
  'onsails/lspkind-nvim',
  module = "lspkind",
  config = conf.lspkind,
}

plugin {
  'hrsh7th/nvim-cmp',
  module = { 'cmp' },
  event = { "InsertEnter", "CmdlineEnter" },
  config = conf.cmp,
}

-- Snippets
plugin {
  'saadparwaiz1/cmp_luasnip',
  after = { "nvim-cmp" },
}
plugin {
  'L3MON4D3/LuaSnip',
  module = { 'luasnip' },
}
plugin {
  'rafamadriz/friendly-snippets',
  after = { 'LuaSnip' },
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end
}

-- LSP
plugin {
  'hrsh7th/cmp-nvim-lsp',
  module = { "cmp_nvim_lsp" },
}
plugin {
  'hrsh7th/cmp-nvim-lsp-signature-help',
  module = { 'cmp_nvim_lsp_signature_help' },
}

-- Others
plugin {
  'hrsh7th/cmp-buffer',
  after = { "nvim-cmp" },
}
plugin {
  'hrsh7th/cmp-path',
  after = { "nvim-cmp" },
}
plugin {
  'hrsh7th/cmp-cmdline',
  after = { "nvim-cmp" },
}
plugin {
  "windwp/nvim-autopairs",
  event = {
    "insertenter",
  },
  after = "nvim-cmp",
  config = conf.autopairs
}
