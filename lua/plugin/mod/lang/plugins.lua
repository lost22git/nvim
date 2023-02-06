local plugin = require('plugin.pack').register_plugin
local TS_conf = require('plugin.mod.lang.TS_config')
local LS_conf = require('plugin.mod.lang.LS_config')

plugin {
  'nvim-treesitter/nvim-treesitter',
  module = { "nvim-treesitter" },
  run = function()
    local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    ts_update()
  end,
  config = TS_conf.treesitter,
}
plugin {
  'nvim-treesitter/nvim-treesitter-context',
  cmd = { "TSContextEnable" },
  config = function()
    require('treesitter-context').setup {}
  end
}

plugin {
  "williamboman/mason.nvim",
  cmd = { "Mason" },
  module = { "mason" },
  config = LS_conf.mason,
}

plugin {
  "neovim/nvim-lspconfig",
  module = { "lspconfig" },
  cmd = { "LspInfo", "LspStart" },
  config = LS_conf.lspconfig,
}

plugin {
  "jose-elias-alvarez/null-ls.nvim",
  cmd = { "NullLsInfo" },
  after = { "nvim-lspconfig" },
  config = LS_conf.null_ls,
}

plugin {
  "glepnir/lspsaga.nvim",
  cmd = { "Lspsaga" },
  after = { "nvim-lspconfig" },
  config = LS_conf.lspsaga,
}


plugin {
  'simrat39/rust-tools.nvim',
  ft = "rust",
  -- cmd = { "RustReloadWorkspace" },
  -- after = { 'nvim-lspconfig' },
  config = LS_conf.rust,
}

plugin {
  'saecki/crates.nvim',
  event = { "BufRead Cargo.toml" },
  requires = { { 'nvim-lua/plenary.nvim' } },
  config = function()
    require('crates').setup()
  end,
}

plugin {
  "nvim-neorg/neorg",
  run = ":Neorg sync-parsers", -- This is the important bit!
  ft = "norg",
  config = LS_conf.neorg,
}

plugin {
  "akinsho/flutter-tools.nvim",
  requires = 'nvim-lua/plenary.nvim',
  cmd = { 'FlutterLspRestart' },
  -- after = { 'nvim-lspconfig' },
  config = LS_conf.flutter,
}
