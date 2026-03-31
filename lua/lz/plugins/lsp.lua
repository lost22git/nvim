-- [nfnl] fnl/lz/plugins/lsp.fnl
local _local_1_ = require("core.utils")
local get_mason_path = _local_1_.get_mason_path
local lsp_with_server = _local_1_.lsp_with_server
local function capabilities()
  local cmp = require("blink.cmp")
  local opts = {textDocument = {semanticTokens = {multilineTokenSupport = true}}}
  return vim.tbl_deep_extend("force", cmp.get_lsp_capabilities(), opts)
end
local function _2_()
  vim.lsp.config("*", {root_markers = {".git"}, capabilities = capabilities()})
  vim.lsp.config("liger", {cmd = {"liger"}, filetypes = {"crystal"}, root_markers = {"shard.yml", ".git"}})
  local function _3_(_241)
    return vim.lsp.config("elixirls", {cmd = {_241}})
  end
  lsp_with_server("elixir-ls", _3_)
  vim.lsp.config("flix", {cmd = {"flix", "lsp"}, filetypes = {"flix"}, root_markers = {"flix.toml"}})
  vim.lsp.config("nim_langserver", {settings = {nim = {inlayHints = {exceptionHints = {enable = false}}}}})
  vim.lsp.config("raku_navigator", {cmd = {"raku-navigator", "--stdio"}})
  vim.lsp.config("zls", {settings = {zls = {enable_snippets = true, highlight_global_var_declarations = true, enable_argument_placeholders = false}}})
  return vim.lsp.enable({"dockerls", "kulala_ls", "marksman", "bashls", "nushell", "powershell_es", "clojure_lsp", "elixirls", "dartls", "emmylua_ls", "fennel_ls", "fsautocomplete", "gleam", "gradle_ls", "gopls", "hls", "julials", "koka", "kotlin_lsp", "ocamllsp", "ols", "racket_langserver", "roc_ls", "rust_analyzer", "sourcekit", "ty", "unison", "v_analyzer", "zls", "html", "htmx"})
end
return {{"neovim/nvim-lspconfig", cmd = "LspStart", dependencies = {{"deathbeam/lspecho.nvim", opts = {}}, {"rachartier/tiny-inline-diagnostic.nvim", opts = {preset = "ghost"}}}, config = _2_}, {"williamboman/mason.nvim", cmd = "Mason", opts = {install_root_dir = get_mason_path(), PATH = "prepend", ui = {backdrop = vim.g.zz.backdrop}}}}
