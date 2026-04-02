-- [nfnl] fnl/lz/plugins/lsp.fnl
local _local_1_ = require("core.utils")
local get_mason_path = _local_1_.get_mason_path
local lsp_with_server = _local_1_.lsp_with_server
local function _2_()
  vim.lsp.config("liger", {cmd = {"liger"}, filetypes = {"crystal"}, root_markers = {"shard.yml", ".git"}})
  local function _3_(_241)
    return vim.lsp.config("elixirls", {cmd = {_241}})
  end
  lsp_with_server("elixir-ls", _3_)
  vim.lsp.config("flix", {cmd = {"flix", "lsp"}, filetypes = {"flix"}, root_markers = {"flix.toml"}})
  vim.lsp.config("nim_langserver", {settings = {nim = {inlayHints = {exceptionHints = {enable = false}}}}})
  vim.lsp.config("raku_navigator", {cmd = {"raku-navigator", "--stdio"}})
  vim.lsp.config("zls", {settings = {zls = {enable_snippets = true, highlight_global_var_declarations = true, enable_argument_placeholders = false}}})
  return vim.lsp.enable({"fennel_ls"})
end
return {{"neovim/nvim-lspconfig", config = _2_, lazy = false}, {"deathbeam/lspecho.nvim", event = "LspAttach", opts = {}}, {"rachartier/tiny-inline-diagnostic.nvim", event = "LspAttach", opts = {preset = "ghost"}}, {"williamboman/mason.nvim", cmd = "Mason", opts = {install_root_dir = get_mason_path(), PATH = "prepend", ui = {backdrop = vim.g.zz.backdrop}}}}
