-- [nfnl] fnl/core/lsp.fnl
local _local_1_ = require("core.utils")
local lsp_with_server = _local_1_.lsp_with_server
local function _2_(_, bufid)
  return vim.diagnostic.open_float(bufid, {scope = "cursor", focurs = false})
end
vim.diagnostic.config({severity_sort = true, jump = {on_jump = _2_}, virtual_text = false})
local function on_attach(client, bufid)
  require("core.maps").lsp(bufid)
  do
    local has_blink_cmp, _ = pcall(require, "blink.cmp")
    if not has_blink_cmp then
      pcall(vim.lsp.completion.enable, true, client.id, bufid, {autotrigger = true})
    else
    end
  end
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
  local opts = {textDocument = {semanticTokens = {multilineTokenSupport = true}}}
  local has_blink_cmp, blink_cmp = pcall(require, "blink.cmp")
  if has_blink_cmp then
    return blink_cmp.get_lsp_capabilities(opts)
  else
    return vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), opts)
  end
end
vim.lsp.config("*", {root_markers = {".git"}, capabilities = capabilities()})
vim.lsp.config("liger", {cmd = {"liger"}, filetypes = {"crystal"}, root_markers = {"shard.yml", ".git"}})
local function _8_(_241)
  return vim.lsp.config("elixirls", {cmd = {_241}})
end
lsp_with_server("elixir-ls", _8_)
vim.lsp.config("flix", {cmd = {"flix", "lsp"}, filetypes = {"flix"}, root_markers = {"flix.toml"}})
vim.lsp.config("nim_langserver", {settings = {nim = {inlayHints = {exceptionHints = {enable = false}}}}})
vim.lsp.config("raku_navigator", {cmd = {"raku-navigator", "--stdio"}})
return vim.lsp.enable({"fennel_ls"})
