local M = {
  'neovim/nvim-lspconfig',
  enabled = not vim.g.vscode,
  cmd = { 'LspInfo', 'LspStart', 'LspLog' },
  dependencies = {
    { 'glepnir/lspsaga.nvim' },
  },
}

local function create_user_command_LualsRestart()
  local callback = function(input)
    local library_map = {
      vim = {
        vim.env.VIMRUNTIME,
        '${3rd}/luv/library',
      },
      all = {
        '${3rd}/luv/library',
        unpack(vim.api.nvim_get_runtime_file('', true)),
      },
    }
    local mode, force = unpack(vim.fn.split(input.fargs[1], '-', false))

    local new_val = library_map[mode]
    local old_val = vim.g.lua_ls_settings_workspace_library

    if force ~= 'force' and require('core.utils').tbl_includes(old_val, new_val) then
      vim.notify('[LualsRestart] paths included, nothing todo')
    else
      vim.g.lua_ls_settings_workspace_library = new_val
      vim.cmd([[ LspRestart lua_ls ]])
    end
  end

  local opts = {
    nargs = 1,
    complete = function(_, _, _) return { 'vim', 'all', 'vim-force', 'all-force' } end,
  }

  vim.api.nvim_create_user_command('LualsRestart', callback, opts)
end

function M.config()
  local lspconfig = require('lspconfig')
  local U = require('core.utils')

  local lsp_server_found = U.lsp_server_found
  local get_lsp_server_package_path = U.get_lsp_server_package_path

  local capabilities = U.lsp_cmp_capabilities()
  local on_attach = function(client, bufnr) U.lsp_on_attach(client, bufnr) end

  -------- LSP Servers config ----------

  -- `:help lspconfig-all`

  -- Lua
  lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        telemetry = {
          enable = false,
        },
      },
    },
    on_init = function(client)
      if client.workspace_folders then
        local path = vim.uv.fs_realpath(client.workspace_folders[1].name)
        local nvim_config_path = vim.fn.stdpath('config')
        print('lua_ls workspace path:', path)
        local nvim_config_real_path =
          vim.uv.fs_realpath(type(nvim_config_path) == 'table' and nvim_config_path[1] or tostring(nvim_config_path))
        print('lua_ls nvim config path:', nvim_config_real_path)
        if nvim_config_real_path and path ~= nvim_config_real_path:sub(1, #path) then
          -- If not in Neovim and not single file
          -- Use `client.config.settings.Lua`
          print('lua_ls settings:', vim.inspect(client.config.settings.Lua))
          return
        end
      end

      -- If in Neovim or single file
      -- Add these settings
      print('lua_ls add Neovim runtime')
      vim.g.lua_ls_settings_workspace_library = vim.g.lua_ls_settings_workspace_library
        or {
          vim.env.VIMRUNTIME,
          '${3rd}/luv/library',
        }
      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
        },
        workspace = {
          checkThirdParty = false,
          library = vim.g.lua_ls_settings_workspace_library,
        },
      })

      create_user_command_LualsRestart()
      print('lua_ls settings:', vim.inspect(client.config.settings.Lua))
    end,
  })

  -- Markdown
  lspconfig.marksman.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Dockerfile
  lsp_server_found(
    'docker-langserver',
    function(server_path)
      lspconfig.dockerls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { server_path, '--stdio' },
      })
    end
  )

  -- TOML
  lspconfig.taplo.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- JSON
  lspconfig.jsonls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- YAML
  lspconfig.yamlls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- XML
  lspconfig.lemminx.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Powershell
  lspconfig.powershell_es.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    bundle_path = get_lsp_server_package_path('powershell-editor-services'),
  })

  -- Nushell
  lspconfig.nushell.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.g.markdown_fenced_languages = {
    'ts=typescript',
  }

  -- Deno  for js jsx ts tsx
  --   lspconfig.denols.setup {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --     root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  --     single_file_support = true
  --   }

  -- Typescript
  lspconfig.ts_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern('package.json'),
    single_file_support = true,
  })

  -- Html
  lspconfig.html.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Htmx
  lsp_server_found(
    'htmx-lsp',
    function(server_path)
      lspconfig.htmx.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { server_path },
      })
    end
  )

  -- Tailwindcss
  lsp_server_found(
    'tailwindcss-language-server',
    function(server_path)
      lspconfig.tailwindcss.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { server_path, '--stdio' },
      })
    end
  )

  -- SVELTE  (requires typescript-language-server)
  lspconfig.svelte.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Crystal
  lspconfig.crystalline.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Java
  lsp_server_found(
    'jdtls',
    function(server_path)
      lspconfig.jdtls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { server_path },
      })
    end
  )

  -- Gradle
  lspconfig.gradle_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Go
  lspconfig.gopls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Nim
  lspconfig.nim_langserver.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Zig
  lspconfig.zls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      zls = {
        enable_snippets = true,
        enable_argument_placeholders = false,
        highlight_global_var_declarations = true,
      },
    },
  })

  -- V
  lspconfig.vls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Odin
  lspconfig.ols.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- OCaml
  lspconfig.ocamllsp.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Koka
  lspconfig.koka.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Gleam
  lspconfig.gleam.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = function(fname)
      local patterns = { 'gleam.toml', '.git' }
      return vim.fs.root(fname, patterns)
    end,
  })

  -- Elixir
  lsp_server_found('elixir-ls', function(server_path)
    lspconfig.elixirls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { server_path },
      root_dir = function(fname)
        local patterns = { 'mix.exs', '.git' }
        return vim.fs.root(fname, patterns)
      end,
    })
  end)

  -- Python
  lsp_server_found(
    'pyright-langserver',
    function(server_path)
      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { server_path, '--stdio' },
      })
    end
  )

  -- Julia
  lspconfig.julials.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    on_new_config = function(new_config, _)
      local julia = vim.fn.expand('~/.julia/environments/nvim-lspconfig/bin/julia')
      -- local julia_found = require('lspconfig').util.path.is_file(julia)
      local julia_found = (vim.uv.fs_stat(julia) or {}).type == 'file'
      if julia_found then new_config.cmd[1] = julia end
    end,
  })

  -- Clojure
  lsp_server_found(
    'clojure-lsp',
    function(server_path)
      lspconfig.clojure_lsp.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { server_path },
      })
    end
  )

  -- Fennel
  lspconfig.fennel_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Swift
  lspconfig.sourcekit.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Dart
  lspconfig.dartls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = function(fname)
      local patterns = { 'pubspec.yaml', '.git' }
      return vim.fs.root(fname, patterns)
    end,
  })

  -- Kulala
  lspconfig.kulala_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

return M
