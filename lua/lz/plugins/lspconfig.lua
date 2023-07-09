local M = {
  "neovim/nvim-lspconfig",
  cmd = { 'LspInfo', 'LspStart', 'LspLog' },
  dependencies = {
    "glepnir/lspsaga.nvim",
    "jose-elias-alvarez/null-ls.nvim",
  }
}

function M.config()
  local lspconfig = require('lspconfig')
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
  lspconfig.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('lua-language-server') },
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
  lspconfig.powershell_es.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    bundle_path = get_lsp_server_package_path('powershell-editor-services')
  }

  vim.g.markdown_fenced_languages = {
    "ts=typescript"
  }
  -- Deno language server for js jsx ts tsx
  lspconfig.denols.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
    single_file_support = true
  }
  -- typescript-language-server
  lspconfig.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path("typescript-language-server"), "--stdio" },
    root_dir = lspconfig.util.root_pattern("package.json"),
    single_file_support = false
  }
  -- SVELTE language server (requires typescript-language-server)
  lspconfig.svelte.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path("svelteserver"), "--stdio" }
  }
  -- Tailwindcss language server
  lspconfig.tailwindcss.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path("tailwindcss-language-server"), "--stdio" }
  }

  -- Markdown language server
  lspconfig.marksman.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    cmd          = { get_lsp_server_path("marksman"), "server" }
  }

  -- TOML language server
  lspconfig.taplo.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path("taplo"), "lsp", "stdio" }
  }

  -- JSON language server
  lspconfig.jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path("vscode-json-language-server"), "--stdio" }
  }

  -- YAML language server
  lspconfig.yamlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path("yaml-language-server"), "--stdio" }
  }

  -- XML language server
  lspconfig.lemminx.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('lemminx') }
  }

  --Dockerfile language server
  lspconfig.dockerls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('docker-langserver'), '--stdio' }
  }

  -- Python language server
  lspconfig.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('pyright-langserver'), "--stdio" }
  }

  -- Julia language server
  lspconfig.julials.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- Gradle language server
  lspconfig.gradle_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('gradle-language-server') }
  }

  -- Go language server
  lspconfig.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('gopls') }
  }
  -- Zig language server
  lspconfig.zls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { get_lsp_server_path('zls') }
  }
  -- V language server
  lspconfig.vls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  end

return M
