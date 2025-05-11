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

  vim.lsp.config('*', {
    root_markers = { '.git' },
    capabilities = require('core.utils').lsp_capabilities(),
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      local buf = args.buf
      require('core.utils').lsp_on_attach(client, buf)
    end,
  })

  -- :help lspconfig-all

  local lspconfig = require('lspconfig')
  local lsp_with_server = require('core.utils').lsp_with_server

  -- Lua
  lspconfig.lua_ls.setup({
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

  -- Kulala
  lspconfig.kulala_ls.setup({})

  -- Markdown
  -- lspconfig.marksman.setup({
  -- })

  -- Dockerfile
  lsp_with_server(
    'docker-langserver',
    function(server_path) lspconfig.dockerls.setup({ cmd = { server_path, '--stdio' } }) end
  )

  -- JSON
  lspconfig.jsonls.setup({})

  -- TOML
  lspconfig.taplo.setup({})

  -- XML
  lspconfig.lemminx.setup({})

  -- YAML
  lspconfig.yamlls.setup({})

  -- Nushell
  lspconfig.nushell.setup({})

  -- Powershell
  lspconfig.powershell_es.setup({
    bundle_path = require('core.utils').lsp_server_package_path('powershell-editor-services'),
  })

  -- Deno  for js jsx ts tsx
  -- lspconfig.denols.setup({})

  -- Typescript
  lspconfig.ts_ls.setup({})

  -- Html
  lspconfig.html.setup({})

  -- Htmx
  lsp_with_server('htmx-lsp', function(server_path) lspconfig.htmx.setup({ cmd = { server_path } }) end)

  -- Tailwindcss
  lsp_with_server('tailwindcss-language-server', function(server_path)
    lspconfig.tailwindcss.setup({
      cmd = { server_path, '--stdio' },
      root_dir = function(fname)
        local patterns = {
          'tailwind.config.js',
          'tailwind.config.cjs',
          'tailwind.config.mjs',
          'tailwind.config.ts',
        }
        return vim.fs.root(fname, patterns)
      end,
    })
  end)

  -- SVELTE  (requires typescript-language-server)
  lspconfig.svelte.setup({})

  -- Clojure
  lsp_with_server('clojure-lsp', function(server_path)
    lspconfig.clojure_lsp.setup({
      cmd = { server_path },
      root_dir = function(fname)
        local patterns = {
          'project.clj',
          'deps.edn',
          'build.boot',
          'shadow-cljs.edn',
          'bb.edn',
        }
        return vim.fs.root(fname, patterns)
      end,
    })
  end)

  -- Crystal
  lspconfig.crystalline.setup({})

  -- Dart
  lspconfig.dartls.setup({
    root_dir = function(fname)
      local patterns = { 'pubspec.yaml', '.git' }
      return vim.fs.root(fname, patterns)
    end,
  })

  -- Elixir
  lsp_with_server('elixir-ls', function(server_path) lspconfig.elixirls.setup({ cmd = { server_path } }) end)

  -- Fennel
  lspconfig.fennel_ls.setup({})

  -- Gleam
  lspconfig.gleam.setup({
    root_dir = function(fname)
      local patterns = { 'gleam.toml', '.git' }
      return vim.fs.root(fname, patterns)
    end,
  })

  -- Gradle
  lspconfig.gradle_ls.setup({})

  -- Go
  lspconfig.gopls.setup({})

  -- Julia
  lspconfig.julials.setup({
    on_new_config = function(new_config, _)
      local julia = vim.fn.expand('~/.julia/environments/nvim-lspconfig/bin/julia')
      local julia_found = (vim.uv.fs_stat(julia) or {}).type == 'file'
      if julia_found then new_config.cmd[1] = julia end
    end,
  })

  -- Koka
  lspconfig.koka.setup({})

  -- Nim
  lspconfig.nim_langserver.setup({})

  -- OCaml
  lspconfig.ocamllsp.setup({})

  -- Odin
  lspconfig.ols.setup({})

  -- Racket
  lspconfig.racket_langserver.setup({})

  -- Raku
  lspconfig.raku_navigator.setup({ cmd = { 'raku-navigator', '--stdio' } })

  -- Swift
  lspconfig.sourcekit.setup({})

  -- V
  lspconfig.vls.setup({})

  -- Zig
  lspconfig.zls.setup({
    settings = {
      zls = {
        enable_snippets = true,
        enable_argument_placeholders = false,
        highlight_global_var_declarations = true,
      },
    },
  })
end

return {
  M,
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {
      install_root_dir = require('core.utils').get_mason_path(),
      PATH = 'prepend',
      ui = { backdrop = vim.g.ZZ.backdrop },
    },
  },
}
