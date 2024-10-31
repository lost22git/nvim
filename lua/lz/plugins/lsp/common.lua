local M = {}

local function lsp_highlight_document_on_cursorhold(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_highlight_document_on_cursorhold", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        vim.lsp.buf.clear_references()
      end,
      buffer = bufnr,
    })
  end
end

local function lsp_diagnostic_on_cursorhold(client, bufnr)
  vim.api.nvim_create_augroup("lsp_diagnostic_on_cursorhold", { clear = true })
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, opts)
    end
  })
end

local augroup_format = vim.api.nvim_create_augroup("lsp_format_on_save", {})
local function lsp_format_on_save(client, bufnr)
  -- if client.server_capabilities.documentFormattingProvider then
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup_format,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format {
          bufnr = bufnr,
          timeout_ms = 2000,
          -- async = true,
        }
      end,
    })
  end
end

local maps = require("core.maps")
function M.on_attach(client, bufnr)
  --Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- 按键配置
  maps.lsp(bufnr)

  -- autocmd
  lsp_highlight_document_on_cursorhold(client, bufnr)
  -- lsp_diagnostic_on_cursorhold(client, bufnr)
  lsp_format_on_save(client, bufnr)
end

function M.cmp_capabilities()
  return require('cmp_nvim_lsp').default_capabilities()
end

-- capabilities 配置
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.preselectSupport = true
M.capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
M.capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
M.capabilities.textDocument.completion.completionItem.deprecatedSupport = true
M.capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
M.capabilities.textDocument.completion.completionItem.tagSupport = {
  valueSet = { 1 },
}
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}
M.capabilities.textDocument.codeAction = {
  dynamicRegistration = false,
  codeActionLiteralSupport = {
    codeActionKind = {
      valueSet = {
        "",
        "quickfix",
        "refactor",
        "refactor.extract",
        "refactor.inline",
        "refactor.rewrite",
        "source",
        "source.organizeImports",
      },
    },
  },
}


function M.some_config()
  -- lspkind
  vim.lsp.protocol.CompletionItemKind = {
    '', -- Text
    '', -- Method
    '', -- Function
    '', -- Constructor
    '', -- Field
    '', -- Variable
    '', -- Class
    'ﰮ', -- Interface
    '', -- Module
    '', -- Property
    '', -- Unit
    '', -- Value
    '', -- Enum
    '', -- Keyword
    '﬌', -- Snippet
    '', -- Color
    '', -- File
    '', -- Reference
    '', -- Folder
    '', -- EnumMember
    '', -- Constant
    '', -- Struct
    '', -- Event
    'ﬦ', -- Operator
    '', -- TypeParameter
  }


  ------------------------------- Diagnostic config

  -- Diagnostic signs
  local signs = {
    Error = "",
    Warn = "",
    Info = "",
    Hint = "",
  }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  local codes = {
    no_matching_function = {
      message = " Can't find a matching function",
      "redundant-parameter",
      "ovl_no_viable_function_in_call",
    },
    empty_block = {
      message = " That shouldn't be empty here",
      "empty-block",
    },
    missing_symbol = {
      message = " Here should be a symbol",
      "miss-symbol",
    },
    expected_semi_colon = {
      message = " Remember the `;` or `,`",
      "expected_semi_declaration",
      "miss-sep-in-table",
      "invalid_token_after_toplevel_declarator",
    },
    redefinition = {
      message = " That variable was defined before",
      "redefinition",
      "redefined-local",
    },
    no_matching_variable = {
      message = " Can't find that variable",
      "undefined-global",
      "reportUndefinedVariable",
    },
    trailing_whitespace = {
      message = " Remove trailing whitespace",
      "trailing-whitespace",
      "trailing-space",
    },
    unused_variable = {
      message = " Don't define variables you don't use",
      "unused-local",
    },
    unused_function = {
      message = " Don't define functions you don't use",
      "unused-function",
    },
    useless_symbols = {
      message = " Remove that useless symbols",
      "unknown-symbol",
    },
    wrong_type = {
      message = " Try to use the correct types",
      "init_conversion_failed",
    },
    undeclared_variable = {
      message = " Have you delcared that variable somewhere?",
      "undeclared_var_use",
    },
    lowercase_global = {
      message = " Should that be a global? (if so make it uppercase)",
      "lowercase-global",
    },
  }

  vim.diagnostic.config({
    float = {
      focusable = false,
      border = "single",
      scope = "line",
      format = function(diagnostic)
        -- dump(diagnostic)
        if diagnostic.user_data == nil then
          return diagnostic.message
        elseif vim.tbl_isempty(diagnostic.user_data) then
          return diagnostic.message
        end
        local code = diagnostic.user_data.lsp.code
        for _, table in pairs(codes) do
          if vim.tbl_contains(table, code) then
            return table.message
          end
        end
        return diagnostic.message
      end,
      header = { "Cursor Diagnostics:", "DiagnosticHeader" },
      prefix = function(diagnostic, i, total)
        local icon, highlight
        if diagnostic.severity == 1 then
          icon = ""
          highlight = "DiagnosticError"
        elseif diagnostic.severity == 2 then
          icon = ""
          highlight = "DiagnosticWarn"
        elseif diagnostic.severity == 3 then
          icon = ""
          highlight = "DiagnosticInfo"
        elseif diagnostic.severity == 4 then
          icon = ""
          highlight = "DiagnosticHint"
        end
        return i .. "/" .. total .. " " .. icon .. "  ", highlight
      end,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = true,
    severity_sort = true,
  })
end

return M
