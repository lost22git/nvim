-- [nfnl] fnl/lz/plugins/lsp.fnl
local _local_1_ = require("core.utils")
local get_mason_path = _local_1_.get_mason_path
local lsp_on_attach = _local_1_.lsp_on_attach
local lsp_capabilities = _local_1_.lsp_capabilities
local lsp_with_server = _local_1_.lsp_with_server
local function _2_()
  vim.diagnostic.config({severity_sort = true, float = true, jump = {float = true}, virtual_text = false})
  vim.lsp.config("*", {root_markers = {".git"}, capabilities = lsp_capabilities()})
  local function _3_(_241)
    return lsp_on_attach(assert(vim.lsp.get_client_by_id(_241.data.client_id)), _241.buf)
  end
  vim.api.nvim_create_autocmd("LspAttach", {callback = _3_})
  vim.lsp.config("liger", {cmd = {"liger"}, filetypes = {"crystal"}, root_markers = {"shard.yml", ".git"}})
  local function _4_(_241)
    return vim.lsp.config("elixirls", {cmd = {_241}})
  end
  lsp_with_server("elixir-ls", _4_)
  vim.lsp.config("flix", {cmd = {"flix", "lsp"}, filetypes = {"flix"}, root_markers = {"flix.toml"}})
  vim.lsp.config("nim_langserver", {settings = {nim = {inlayHints = {exceptionHints = {enable = false}}}}})
  vim.lsp.config("raku_navigator", {cmd = {"raku-navigator", "--stdio"}})
  vim.lsp.config("zls", {settings = {zls = {enable_snippets = true, highlight_global_var_declarations = true, enable_argument_placeholders = false}}})
  return vim.lsp.enable({"dockerls", "kulala_ls", "marksman", "bashls", "nushell", "powershell_es", "clojure_lsp", "dartls", "emmylua_ls", "fennel_ls", "gleam", "gradle_ls", "gopls", "hls", "julials", "koka", "kotlin_lsp", "ocamllsp", "ols", "racket_langserver", "roc_ls", "rust_analyzer", "sourcekit", "ty", "unison", "v_analyzer", "html", "htmx"})
end
return {{"neovim/nvim-lspconfig", cmd = {"LspInfo", "LspStart", "LspLog"}, dependencies = {{"deathbeam/lspecho.nvim", opts = {}}, {"rachartier/tiny-inline-diagnostic.nvim", opts = {preset = "ghost"}}}, config = _2_}, {"williamboman/mason.nvim", cmd = "Mason", opts = {install_root_dir = get_mason_path(), PATH = "prepend", ui = {backdrop = vim.g.zz.backdrop}}}}
