local M = {
  "neovim/nvim-lspconfig",
  cmd = { 'LspInfo', 'LspStart', 'LspLog' },
  dependencies = {
    "glepnir/lspsaga.nvim"
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


  -------- LSP Servers config ----------

  -- Lua language server
  if get_lsp_server_path('lua-language-server') ~= '' then
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
  end

  -- Powershell language server
  if get_lsp_server_package_path('powershell-editor-services') ~= '' then
    lspconfig.powershell_es.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      bundle_path = get_lsp_server_package_path('powershell-editor-services')
    }
  end

  vim.g.markdown_fenced_languages = {
    "ts=typescript"
  }

  -- Deno language server for js jsx ts tsx
  -- if vim.fn.exepath('deno') ~= '' then
  --   lspconfig.denols.setup {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --     root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  --     single_file_support = true
  --   }
  -- end
  -- typescript-language-server
  if get_lsp_server_path("typescript-language-server") ~= '' then
    lspconfig.tsserver.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path("typescript-language-server"), "--stdio" },
      root_dir = lspconfig.util.root_pattern("package.json"),
      single_file_support = true
    }
  end

  -- SVELTE language server (requires typescript-language-server)
  if get_lsp_server_path("svelteserver") ~= '' then
    lspconfig.svelte.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path("svelteserver"), "--stdio" }
    }
  end

  -- Tailwindcss language server
  if get_lsp_server_path("tailwindcss-language-server") ~= '' then
    lspconfig.tailwindcss.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path("tailwindcss-language-server"), "--stdio" }
    }
  end

  -- Markdown language server
  if get_lsp_server_path("marksman") ~= '' then
    lspconfig.marksman.setup {
      on_attach    = on_attach,
      capabilities = capabilities,
      cmd          = { get_lsp_server_path("marksman"), "server" }
    }
  end

  -- TOML language server
  if get_lsp_server_path("taplo") ~= '' then
    lspconfig.taplo.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path("taplo"), "lsp", "stdio" }
    }
  end

  -- JSON language server
  if get_lsp_server_path("vscode-json-language-server") ~= '' then
    lspconfig.jsonls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path("vscode-json-language-server"), "--stdio" }
    }
  end

  -- YAML language server
  if get_lsp_server_path("yaml-language-server") ~= '' then
    lspconfig.yamlls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path("yaml-language-server"), "--stdio" }
    }
  end

  -- XML language server
  if get_lsp_server_path('lemminx') ~= '' then
    lspconfig.lemminx.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path('lemminx') }
    }
  end

  --Dockerfile language server
  if get_lsp_server_path('docker-langserver') ~= '' then
    lspconfig.dockerls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path('docker-langserver'), '--stdio' }
    }
  end

  -- Python language server
  if get_lsp_server_path('pyright-langserver') ~= '' then
    lspconfig.pyright.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path('pyright-langserver'), "--stdio" }
    }
  end

  -- Julia language server
  if vim.fn.exepath('julia') ~= '' then
    lspconfig.julials.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end

  -- Gradle language server
  if get_lsp_server_path('gradle-language-server') ~= '' then
    lspconfig.gradle_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path('gradle-language-server') }
    }
  end

  -- Go language server
  if get_lsp_server_path('gopls') ~= '' then
    lspconfig.gopls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path('gopls') }
    }
  end

  -- Zig language server
  if get_lsp_server_path('zls') ~= '' then
    lspconfig.zls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path('zls') }
    }
  end

  -- V language server
  if get_lsp_server_path('v') ~= '' then
    lspconfig.vls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end
end

return M
