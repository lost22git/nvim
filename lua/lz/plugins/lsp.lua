-- [nfnl] fnl/lz/plugins/lsp.fnl
local _local_1_ = require("core.utils")
local get_mason_path = _local_1_.get_mason_path
return {{"neovim/nvim-lspconfig", lazy = false}, {"deathbeam/lspecho.nvim", event = "LspAttach", opts = {}}, {"rachartier/tiny-inline-diagnostic.nvim", event = "LspAttach", opts = {preset = "ghost"}}, {"williamboman/mason.nvim", cmd = "Mason", opts = {install_root_dir = get_mason_path(), PATH = "prepend", ui = {backdrop = vim.g.zz.backdrop}}}}
