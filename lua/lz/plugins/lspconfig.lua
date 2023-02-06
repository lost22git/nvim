local M = {
  "neovim/nvim-lspconfig",
  cmd = { "LspInfo", "LspStart" },
  dependencies = {
    "glepnir/lspsaga.nvim",
    "jose-elias-alvarez/null-ls.nvim",
  }
}

function M.config()
  local nvim_lsp = require('lspconfig')
  local U = require('core.utils')

  local get_lsp_server_path = U.get_lsp_server_path
  local get_lsp_server_package_path = U.get_lsp_server_package_path

  local capabilities = require('lz.plugins.lsp.common').cmp_capabilities()
  local on_attach = function(client, bufnr)
    require('lz.plugins.lsp.common').on_attach(client, bufnr)
  end

  require('lz.plugins.lsp.common').some_config()


  ------------------------------------- LSP Servers config
  -- Lua language server
  nvim_lsp.sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path("lua-language-server") },
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }

  -- TyepScript language server
  nvim_lsp.tsserver.setup {
    on_attach = on_attach,
    filetypes = { "typescript", "typescriptreact", "typescript.tsx", "ts" },
    cmd = { get_lsp_server_path("typescript-language-server"), "--stdio" },
    capabilities = capabilities,
  }

  -- Lua language server
  -- CSS language server
  -- nvim_lsp.tailwindcss.setup {
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  --   cmd = { get_lsp_client_path("tailwindcss-language-server"), "--stdio" },
  -- }

  -- Dockerfile language server
  nvim_lsp.dockerls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('docker-langserver'), '--stdio' }
  }

  -- Powershell language server
  nvim_lsp.powershell_es.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    bundle_path = get_lsp_server_package_path('powershell-editor-services')
  }


  -- Zig language server
  nvim_lsp.zls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('zls') }
  }

  -- Deno language server
  -- nvim_lsp.denols.setup {
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  -- }

  -- Markdown language server
  nvim_lsp.marksman.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    cmd          = { get_lsp_server_path("marksman"), "server" }
  }

  -- Go language server
  nvim_lsp.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('gopls') }
  }

  -- Gradle language server
  nvim_lsp.gradle_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('gradle-language-server') }
  }

  -- TOML language server
  nvim_lsp.taplo.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path("taplo"), "lsp", "stdio" }
  }

  -- JSON language server
  nvim_lsp.jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path("vscode-json-language-server"), "--stdio" }
  }

  -- YAML language server
  nvim_lsp.yamlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path("yaml-language-server"), "--stdio" }
  }

  -- SVELTE language server
  nvim_lsp.svelte.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path("svelteserver"), "--stdio" }
  }

  -- XML language server
  nvim_lsp.lemminx.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('lemminx') }
  }

  -- Python language server
  nvim_lsp.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('pyright-langserver'), "--stdio" }
  }

  -- Julia language server
  nvim_lsp.julials.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

return M
