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
  nvim_lsp.lua_ls.setup {
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
          -- checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }

  -- Powershell language server
  nvim_lsp.powershell_es.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    bundle_path = get_lsp_server_package_path('powershell-editor-services')
  }

  vim.g.markdown_fenced_languages = {
    "ts=typescript"
  }
  -- Deno language server for js jsx ts tsx
  nvim_lsp.denols.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- SVELTE language server
  nvim_lsp.svelte.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path("svelteserver"), "--stdio" }
  }

  -- Markdown language server
  nvim_lsp.marksman.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    cmd          = { get_lsp_server_path("marksman"), "server" }
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

  -- XML language server
  nvim_lsp.lemminx.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('lemminx') }
  }

  --Dockerfile language server
  nvim_lsp.dockerls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('docker-langserver'), '--stdio' }
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

  -- Gradle language server
  nvim_lsp.gradle_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('gradle-language-server') }
  }

  -- Go language server
  nvim_lsp.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('gopls') }
  }

  -- Zig language server
  nvim_lsp.zls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('zls') }
  }
end

return M
