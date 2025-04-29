local function create_LualsReloadNvim_command()
  local callback = function(input)
    local nvim_library_map = {
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

    local new_val, old_val = nvim_library_map[mode], vim.g.lua_ls_reload_nvim

    if force ~= 'force' and require('core.utils').tbl_includes(old_val, new_val) then
      vim.notify('[LualsReloadNvim] modules have already loaded, nothing todo')
    else
      vim.g.lua_ls_reload_nvim = new_val
      vim.cmd([[ LspRestart lua_ls ]])
    end
  end

  vim.api.nvim_create_user_command('LualsReloadNvim', callback, {
    nargs = 1,
    complete = function() return { 'vim', 'all', 'vim-force', 'all-force' } end,
  })
end

local lua_conditional_settings = {
  {
    cond = function(nvim_config_path, workspace_path)
      return not workspace_path
        or nvim_config_path == workspace_path:sub(1, #nvim_config_path)
        or not (vim.uv.fs_stat(workspace_path .. '/.luarc.json') or vim.uv.fs_stat(workspace_path .. '/.luarc.jsonc'))
    end,
    config = function(client)
      print('lua_ls load nvim modules')
      vim.g.lua_ls_reload_nvim = vim.g.lua_ls_reload_nvim
        or {
          vim.env.VIMRUNTIME,
          '${3rd}/luv/library',
        }
      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        codeLens = { enable = false },
        runtime = { version = 'LuaJIT' },
        workspace = { checkThirdParty = false, library = vim.g.lua_ls_reload_nvim },
      })

      create_LualsReloadNvim_command()
    end,
  },
}

local M = {
  'neovim/nvim-lspconfig',
  cmd = { 'LspInfo', 'LspStart', 'LspLog' },
  dependencies = {
    {
      'deathbeam/lspecho.nvim',
      opts = {},
    },
    {
      'glepnir/lspsaga.nvim',
      opts = {
        beacon = { enable = true },
        code_action = { show_server_name = true },
        finder = { left_width = 0.3, right_width = 0.5, keys = { shuttle = '<Tab>' } },
        outline = { keys = { toggle_or_jump = '<Tab>', jump = 'o' } },
        scroll_preview = { scroll_down = '<C-d>', scroll_up = '<C-u>' },
      },
      config = function(_, opts)
        require('lspsaga').setup(opts)
        require('core.maps').lspsaga()
      end,
    },
  },
}

function M.config()
  vim.diagnostic.config({
    severity_sort = true,
    virtual_text = false,
    virtual_lines = { current_line = true },
  })

  local lspconfig, U = require('lspconfig'), require('core.utils')

  local with_lsp_server = U.with_lsp_server
  local get_lsp_server_package_path = U.get_lsp_server_package_path

  local capabilities = U.lsp_capabilities()
  local on_attach = function(client, bufnr) U.lsp_on_attach(client, bufnr) end

  -------- LSP Servers config ----------

  -- `:help lspconfig-all`

  -- Lua
  lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    on_init = function(client)
      local nvim_config_path = vim.fn.stdpath('config')
      local nvim_config_real_path =
        vim.uv.fs_realpath(type(nvim_config_path) == 'table' and nvim_config_path[1] or tostring(nvim_config_path))
      print('lua_ls nvim config path:', nvim_config_real_path)

      local workspace_path = nil
      if client.workspace_folders then workspace_path = vim.uv.fs_realpath(client.workspace_folders[1].name) end
      print('lua_ls workspace path:', workspace_path)

      -- default settings
      client.config.settings.Lua = {
        codeLens = { enable = true },
        completion = { callSnippet = 'Replace' },
        telemetry = { enable = false },
        workspace = { checkThirdParty = false, library = {} },
      }

      -- conditional settings
      for _, s in ipairs(lua_conditional_settings) do
        if s.cond(nvim_config_real_path, workspace_path) then
          s.config(client)
          break
        end
      end

      print('lua_ls settings:', vim.inspect(client.config.settings.Lua))
    end,
  })

  -- Markdown
  -- lspconfig.marksman.setup({
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  -- })

  -- Dockerfile
  with_lsp_server(
    'docker-langserver',
    function(server_path)
      lspconfig.dockerls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { server_path, '--stdio' },
      })
    end
  )

  -- JSON
  lspconfig.jsonls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- TOML
  lspconfig.taplo.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- XML
  lspconfig.lemminx.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- YAML
  lspconfig.yamlls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Nushell
  lspconfig.nushell.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Powershell
  lspconfig.powershell_es.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    bundle_path = get_lsp_server_package_path('powershell-editor-services'),
  })

  -- Deno  for js jsx ts tsx
  -- vim.g.markdown_fenced_languages = {
  --   'ts=typescript',
  -- }
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
  with_lsp_server(
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
  with_lsp_server('tailwindcss-language-server', function(server_path)
    lspconfig.tailwindcss.setup({
      root_dir = function(fname)
        local patterns = {
          'tailwind.config.js',
          'tailwind.config.cjs',
          'tailwind.config.mjs',
          'tailwind.config.ts',
        }
        return vim.fs.root(fname, patterns)
      end,
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { server_path, '--stdio' },
    })
  end)

  -- SVELTE  (requires typescript-language-server)
  lspconfig.svelte.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Clojure
  with_lsp_server('clojure-lsp', function(server_path)
    lspconfig.clojure_lsp.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { server_path },
      root_dir = function(fname)
        local patterns = { 'project.clj', 'deps.edn', 'build.boot', 'shadow-cljs.edn', 'bb.edn', '.git' }
        return vim.fs.root(fname, patterns)
      end,
    })
  end)

  -- Crystal
  lspconfig.crystalline.setup({
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

  -- Elixir
  with_lsp_server('elixir-ls', function(server_path)
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

  -- Fennel
  lspconfig.fennel_ls.setup({
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

  -- Koka
  lspconfig.koka.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Nim
  lspconfig.nim_langserver.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- OCaml
  lspconfig.ocamllsp.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Odin
  lspconfig.ols.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Python
  with_lsp_server(
    'pyright-langserver',
    function(server_path)
      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { server_path, '--stdio' },
      })
    end
  )

  -- Raku
  lspconfig.raku_navigator.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { 'raku-navigator', '--stdio' },
  })

  -- Swift
  lspconfig.sourcekit.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- V
  lspconfig.vls.setup({
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

  -- Kulala
  lspconfig.kulala_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

return {
  M,
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason' },
    opts = {
      install_root_dir = require('core.utils').get_mason_path(),
      PATH = 'prepend',
      ui = {
        border = vim.opt.winborder:get(),
        backdrop = vim.g.LC.backdrop,
      },
    },
  },
}
