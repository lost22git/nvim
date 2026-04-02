-- [nfnl] fnl/core/lsp.fnl
local _local_1_ = require("core.utils")
local lsp_with_server = _local_1_.lsp_with_server
local function _2_(_, bufid)
  return vim.diagnostic.open_float(bufid, {scope = "cursor", focurs = false})
end
vim.diagnostic.config({severity_sort = true, jump = {on_jump = _2_}, virtual_text = false})
local function on_attach(_client, bufid)
  vim.bo[bufid]["omnifunc"] = nil
  local _local_3_ = require("core.maps")
  local lsp_mappings = _local_3_.lsp
  lsp_mappings(bufid)
  return pcall(vim.lsp.codelens.enable, true)
end
local function _6_(_4_)
  local _arg_5_ = _4_.data
  local client_id = _arg_5_.client_id
  local bufid = _4_.buf
  local client = assert(vim.lsp.get_client_by_id(client_id))
  on_attach(client, bufid)
  return nil
end
vim.api.nvim_create_autocmd("LspAttach", {desc = "[LSP] LspAttach", callback = _6_})
local function capabilities()
  local cmp = require("blink.cmp")
  local opts = {textDocument = {semanticTokens = {multilineTokenSupport = true}}}
  return vim.tbl_deep_extend("force", cmp.get_lsp_capabilities(), opts)
end
vim.lsp.config("*", {root_markers = {".git"}, capabilities = capabilities()})
vim.lsp.config("liger", {cmd = {"liger"}, filetypes = {"crystal"}, root_markers = {"shard.yml", ".git"}})
local function _7_(_241)
  return vim.lsp.config("elixirls", {cmd = {_241}})
end
lsp_with_server("elixir-ls", _7_)
vim.lsp.config("flix", {cmd = {"flix", "lsp"}, filetypes = {"flix"}, root_markers = {"flix.toml"}})
vim.lsp.config("nim_langserver", {settings = {nim = {inlayHints = {exceptionHints = {enable = false}}}}})
vim.lsp.config("raku_navigator", {cmd = {"raku-navigator", "--stdio"}})
return vim.lsp.enable({"fennel_ls"})
