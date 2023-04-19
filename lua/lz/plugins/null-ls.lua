local M = {
  "jose-elias-alvarez/null-ls.nvim",
}

function M.config()
  local U = require('core.utils')
  local nls = require('null-ls')
  local fmt = nls.builtins.formatting

  local on_attach = function(client, bufnr)
    require('lz.plugins.lsp.common').on_attach(client, bufnr)
  end

  nls.setup {
    debug = true,
    on_attach = on_attach,
    sources = {
      -- fmt.rome.with {
      --   command = U.get_nulls_source_path('rome')
      -- },
      fmt.black.with { -- format python
        command = U.get_nulls_source_path('black')
      },
    },
  }
end

return M
