-- [nfnl] fnl/core/lsp.fnl
local _local_1_ = require("core.utils")
local lsp_with_server = _local_1_.lsp_with_server
local function _2_(_, bufid)
  return vim.diagnostic.open_float(bufid, {scope = "cursor", focurs = false})
end
vim.diagnostic.config({severity_sort = true, jump = {on_jump = _2_}, virtual_text = false})
local function format_on_save(client, bufid)
  local case_3_, case_4_ = pcall(require, "conform")
  local and_5_ = ((case_3_ == false) and true)
  if and_5_ then
    local _ = case_4_
    and_5_ = client:supports_method("textDocument/formatting")
  end
  if and_5_ then
    local _ = case_4_
    local g = vim.api.nvim_create_augroup("lsp_format_on_save", {})
    local cb
    do
      local partial_7_ = {buffer = bufid, timeout_ms = 1000}
      local function _8_(...)
        return vim.lsp.buf.format(partial_7_, ...)
      end
      cb = _8_
    end
    vim.api.nvim_clear_autocmds({group = g, buffer = bufid})
    return vim.api.nvim_create_autocmd("BufWritePre", {group = g, buffer = bufid, callback = cb})
  else
    return nil
  end
end
local function on_attach(client, bufid)
  vim.bo[bufid]["omnifunc"] = nil
  local _local_10_ = require("core.maps")
  local lsp_mappings = _local_10_.lsp
  lsp_mappings(bufid)
  format_on_save(client, bufid)
  return pcall(vim.lsp.codelens.enable, true)
end
local function _13_(_11_)
  local _arg_12_ = _11_.data
  local client_id = _arg_12_.client_id
  local bufid = _11_.buf
  local client = assert(vim.lsp.get_client_by_id(client_id))
  on_attach(client, bufid)
  return nil
end
vim.api.nvim_create_autocmd("LspAttach", {desc = "[LSP] LspAttach", callback = _13_})
local function capabilities()
  local cmp = require("blink.cmp")
  local opts = {textDocument = {semanticTokens = {multilineTokenSupport = true}}}
  return vim.tbl_deep_extend("force", cmp.get_lsp_capabilities(), opts)
end
vim.lsp.config("*", {root_markers = {".git"}, capabilities = capabilities()})
vim.lsp.config("liger", {cmd = {"liger"}, filetypes = {"crystal"}, root_markers = {"shard.yml", ".git"}})
local function _14_(_241)
  return vim.lsp.config("elixirls", {cmd = {_241}})
end
lsp_with_server("elixir-ls", _14_)
vim.lsp.config("flix", {cmd = {"flix", "lsp"}, filetypes = {"flix"}, root_markers = {"flix.toml"}})
vim.lsp.config("nim_langserver", {settings = {nim = {inlayHints = {exceptionHints = {enable = false}}}}})
vim.lsp.config("raku_navigator", {cmd = {"raku-navigator", "--stdio"}})
return vim.lsp.enable({"fennel_ls"})
