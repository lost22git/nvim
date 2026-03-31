-- [nfnl] fnl/core/lsp.fnl
local _local_1_ = require("core.maps")
local lsp_mappings = _local_1_.lsp
local function format_on_save(client_id, bufid)
  local client = assert(vim.lsp.get_client_by_id(client_id))
  local case_2_, case_3_ = pcall(require, "conform")
  local and_4_ = ((case_2_ == false) and true)
  if and_4_ then
    local _ = case_3_
    and_4_ = client:supports_method("textDocument/formatting")
  end
  if and_4_ then
    local _ = case_3_
    local g = vim.api.nvim_create_augroup("lsp_format_on_save", {})
    local cb
    do
      local partial_6_ = {buffer = bufid, timeout_ms = 1000}
      local function _7_(...)
        return vim.lsp.buf.format(partial_6_, ...)
      end
      cb = _7_
    end
    vim.api.nvim_clear_autocmds({group = g, buffer = bufid})
    return vim.api.nvim_create_autocmd("BufWritePre", {group = g, buffer = bufid, callback = cb})
  else
    return nil
  end
end
local function on_attach(client_id, bufid)
  vim.bo[bufid]["omnifunc"] = nil
  lsp_mappings(bufid)
  format_on_save(client_id, bufid)
  return pcall(vim.lsp.codelens.enable, true)
end
local function _11_(_9_)
  local _arg_10_ = _9_.data
  local client_id = _arg_10_.client_id
  local bufid = _9_.buf
  on_attach(client_id, bufid)
  return nil
end
vim.api.nvim_create_autocmd("LspAttach", {desc = "[LSP] LspAttach", callback = _11_})
local function _12_(_, bufid)
  return vim.diagnostic.open_float(bufid, {scope = "cursor", focurs = false})
end
return vim.diagnostic.config({severity_sort = true, jump = {on_jump = _12_}, virtual_text = false})
