local M = {
  "neovim/nvim-lspconfig",
  enabled = not vim.g.vscode,
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

  -- `:help lspconfig-all`

  -- Lua language server
  lspconfig.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
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

  vim.g.markdown_fenced_languages = {
    "ts=typescript"
  }

  -- Deno language server for js jsx ts tsx
  --   lspconfig.denols.setup {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --     root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  --     single_file_support = true
  --   }

  -- typescript-language-server
  lspconfig.ts_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern("package.json"),
    single_file_support = true
  }

  -- SVELTE language server (requires typescript-language-server)
  lspconfig.svelte.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- Markdown language server
  lspconfig.marksman.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
  }

  -- TOML language server
  lspconfig.taplo.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- JSON language server
  lspconfig.jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- YAML language server
  lspconfig.yamlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- XML language server
  lspconfig.lemminx.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- Julia language server
  lspconfig.julials.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    on_new_config = function(new_config, _)
      local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
      if require 'lspconfig'.util.path.is_file(julia) then
        new_config.cmd[1] = julia
      end
    end
  }

  -- Gradle language server
  lspconfig.gradle_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- Go language server
  lspconfig.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- Zig language server
  lspconfig.zls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      zls = {
        enable_snippets = true,
        enable_argument_placeholders = false,
        highlight_global_var_declarations = true,
      }
    },
  }

  -- V language server
  lspconfig.vls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- nim language server
  lspconfig.nim_langserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }


  -- crystal language server
  lspconfig.crystalline.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- nushell language server
  lspconfig.nushell.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- html language server
  lspconfig.html.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- gleam language server
  lspconfig.gleam.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- odin language server
  lspconfig.ols.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- ocaml language server
  lspconfig.ocamllsp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- koka language server
  lspconfig.koka.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }


  -- Powershell language server
  if get_lsp_server_package_path('powershell-editor-services') ~= '' then
    lspconfig.powershell_es.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      bundle_path = get_lsp_server_package_path('powershell-editor-services')
    }
  end

  -- htmx language server
  if get_lsp_server_path('htmx-lsp') ~= '' then
    lspconfig.htmx.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path('htmx-lsp') },
    }
  end

  -- Tailwindcss language server
  if get_lsp_server_path('tailwindcss-language-server') ~= '' then
    lspconfig.tailwindcss.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path('tailwindcss-language-server'), '--stdio' },
    }
  end

  -- elixir language server
  if get_lsp_server_path('elixir-ls') ~= '' then
    lspconfig.elixirls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path('elixir-ls') }
    }
  end

  -- java language server
  if get_lsp_server_path('jdtls') ~= '' then
    lspconfig.jdtls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { get_lsp_server_path('jdtls') }
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
end

return M
