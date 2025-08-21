-- [nfnl] fnl/lz/plugins/lsp.fnl
local _local_1_ = require("core.utils")
local get_mason_path = _local_1_["get_mason_path"]
local lsp_on_attach = _local_1_["lsp_on_attach"]
local lsp_capabilities = _local_1_["lsp_capabilities"]
local function _2_()
  vim.diagnostic.config({severity_sort = true, float = true, jump = {float = true}, virtual_text = false})
  vim.lsp.config("*", {root_markers = {".git"}, capabilities = lsp_capabilities()})
  local function _3_(_241)
    return lsp_on_attach(assert(vim.lsp.get_client_by_id(_241.data.client_id)), _241.buf)
  end
  vim.api.nvim_create_autocmd("LspAttach", {callback = _3_})
  vim.lsp.config("flix", {cmd = {"flix", "lsp"}, filetypes = {"flix"}, root_markers = {"flix.toml"}})
  vim.lsp.config("nim_langserver", {settings = {nim = {inlayHints = {exceptionHints = {enable = false}}}}})
  vim.lsp.config("raku_navigator", {cmd = {"raku-navigator", "--stdio"}})
  vim.lsp.config("tailwindcss", {root_markers = {"tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts"}})
  vim.lsp.config("zls", {settings = {zls = {enable_snippets = true, highlight_global_var_declarations = true, enable_argument_placeholders = false}}})
  return vim.lsp.enable({"dockerls", "kulala_ls", "marksman", "nushell", "powershell_es", "html", "htmx", "svelte", "vtsls", "clojure_lsp", "crystalline", "dartls", "elixirls", "emmylua_ls", "fennel_ls", "gleam", "gradle_ls", "gopls", "julials", "koka", "kotlin_lsp", "ocamllsp", "ols", "racket_langserver", "roc_ls", "ruff", "rust_analyzer", "sourcekit", "v_analyzer"})
end
return {{"neovim/nvim-lspconfig", cmd = {"LspInfo", "LspStart", "LspLog"}, dependencies = {{"deathbeam/lspecho.nvim", opts = {}}, {"rachartier/tiny-inline-diagnostic.nvim", opts = {preset = "ghost"}}}, config = _2_}, {"williamboman/mason.nvim", cmd = "Mason", opts = {install_root_dir = get_mason_path(), PATH = "prepend", ui = {backdrop = vim.g.zz.backdrop}}}}
