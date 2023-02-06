local M = {}

function M.mason()
  local U = require('core.utils')
  require("mason").setup {
    -- 下载目录
    install_root_dir = U.get_mason_path(),

    ---@type '"prepend"' | '"append"' | '"skip"'
    -- 是否自动添加 bin 目录到 PATH 环境变量
    -- skip 跳过
    -- prepend 添加到 PATH 头部
    -- append 添加到 PATH 尾部
    PATH = "prepend",

    -- python pip 包下载工具
    pip = {
      -- 是否在下载前更新 pip 版本
      upgrade_pip = false,

      -- pip install 用户自定义参数
      -- Example: { "--proxy", "https://proxyserver" }
      install_args = {},
    },

    -- 日志级别
    log_level = vim.log.levels.INFO,

    -- 最大同时下载任务数
    max_concurrent_installers = 4,

    -- github 下载配置
    github = {
      -- The template URL to use when downloading assets from GitHub.
      -- The placeholders are the following (in order):
      -- 1. The repository (e.g. "rust-lang/rust-analyzer")
      -- 2. The release version (e.g. "v0.3.0")
      -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
      download_url_template = "https://github.com/%s/releases/download/%s/%s",
    },

    -- 包下载服务器(提供商)
    -- The provider implementations to use for resolving package metadata (latest version, available versions, etc.).
    -- Accepts multiple entries, where later entries will be used as fallback should prior providers fail.
    -- Builtin providers are:
    --   - mason.providers.registry-api (default) - uses the https://api.mason-registry.dev API
    --   - mason.providers.client                 - uses only client-side tooling to resolve metadata
    providers = {
      "mason.providers.registry-api",
    },

    -- ui 配置
    ui = {
      -- 当打开 :Mason 窗口时是否自动升级包
      check_outdated_packages_on_open = true,

      -- 窗口配置见 :h nvim_open_win()
      border = "none",

      -- 图标配置
      icons = {
        -- The list icon to use for installed packages.
        package_installed = "◍",
        -- The list icon to use for packages that are installing, or queued for installation.
        package_pending = "◍",
        -- The list icon to use for packages that are not installed.
        package_uninstalled = "◍",
      },
      -- 按键配置
      keymaps = {
        -- Keymap to expand a package
        toggle_package_expand = "<CR>",
        -- Keymap to install the package under the current cursor position
        install_package = "i",
        -- Keymap to reinstall/update the package under the current cursor position
        update_package = "u",
        -- Keymap to check for new version for the package under the current cursor position
        check_package_version = "c",
        -- Keymap to update all installed packages
        update_all_packages = "U",
        -- Keymap to check which installed packages are outdated
        check_outdated_packages = "C",
        -- Keymap to uninstall a package
        uninstall_package = "X",
        -- Keymap to cancel a package installation
        cancel_installation = "<C-c>",
        -- Keymap to apply language filter
        apply_language_filter = "<C-f>",
      },
    },
  }
end

function M.lspconfig()
  local nvim_lsp = require('lspconfig')
  local U = require('core.utils')

  local get_lsp_server_path = U.get_lsp_server_path
  local get_lsp_server_package_path = U.get_lsp_server_package_path

  local capabilities = require('plugin.mod.lang.common').cmp_capabilities()
  local on_attach = function(client, bufnr)
    require('plugin.mod.lang.common').on_attach(client, bufnr)
  end

  require('plugin.mod.lang.common').some_config()


  ------------------------------------- LSP servers config
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
  --   cmd = { get_lsp_server_path("tailwindcss-language-server"), "--stdio" },
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

function M.null_ls()
  local U = require('core.utils')
  local nls = require('null-ls')
  local fmt = nls.builtins.formatting

  local on_attach = function(client, bufnr)
    require('plugin.mod.lang.common').on_attach(client, bufnr)
  end

  nls.setup {
    debug = true,
    on_attach = on_attach,
    sources = {
      fmt.rome.with {
        command = U.get_nulls_source_path('rome')
      },
      fmt.black.with {
        command = U.get_nulls_source_path('black')
      },
    },
  }
end

function M.lspsaga()
  local saga = require('lspsaga')
  saga.init_lsp_saga {
    symbol_in_winbar = {
      in_custom = true,
      click_support = function(node, clicks, button, modifiers)
        -- To see all avaiable details: vim.pretty_print(node)
        local st = node.range.start
        local en = node.range['end']
        if button == "l" then
          if clicks == 2 then
            -- double left click to do nothing
          else -- jump to node's starting line+char
            vim.fn.cursor(st.line + 1, st.character + 1)
          end
        elseif button == "r" then
          if modifiers == "s" then
            print "lspsaga" -- shift right click to print "lspsaga"
          end -- jump to node's ending line+char
          vim.fn.cursor(en.line + 1, en.character + 1)
        elseif button == "m" then
          -- middle click to visual select node
          vim.fn.cursor(st.line + 1, st.character + 1)
          vim.cmd "normal v"
          vim.fn.cursor(en.line + 1, en.character + 1)
        end
      end
    }
  }

  require('core.maps').lspsaga()

  local function get_file_name(include_path)
    ---@diagnostic disable-next-line: missing-parameter
    local file_name = require('lspsaga.symbolwinbar').get_file_name()
    if vim.fn.bufname '%' == '' then return '' end
    if include_path == false then return file_name end
    -- Else if include path: ./lsp/saga.lua -> lsp > saga.lua
    local sep = vim.loop.os_uname().sysname == 'Windows' and '\\' or '/'
    local path_list = vim.split(string.gsub(vim.fn.expand '%:~:.:h', '%%', ''), sep)
    local file_path = ''
    for _, cur in ipairs(path_list) do
      file_path = (cur == '.' or cur == '~') and '' or
          file_path .. cur .. ' ' .. '%#LspSagaWinbarSep#>%*' .. ' %*'
    end
    return file_path .. file_name
  end

  local function config_winbar_or_statusline()
    local exclude = {
      ['terminal'] = true,
      ['toggleterm'] = true,
      ['prompt'] = true,
      ['NvimTree'] = true,
      ['drex'] = true,
      ['help'] = true,
    } -- Ignore float windows and exclude filetype
    if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
      vim.wo.winbar = ''
    else
      local ok, lspsaga = pcall(require, 'lspsaga.symbolwinbar')
      local sym
      if ok then sym = lspsaga.get_symbol_node() end
      local win_val = ''
      win_val = get_file_name(true) -- set to true to include path
      if sym ~= nil then win_val = win_val .. sym end
      vim.wo.winbar = win_val
      -- if work in statusline
      -- vim.wo.stl = win_val
    end
  end

  local events = { 'BufEnter', 'BufWinEnter', 'CursorMoved' }
  vim.api.nvim_create_autocmd(events, {
    pattern = '*',
    callback = function() config_winbar_or_statusline() end,
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'LspsagaUpdateSymbol',
    callback = function() config_winbar_or_statusline() end,
  })

end

function M.rust()
  local rt = require('rust-tools')

  local capabilities = require('plugin.mod.lang.common').cmp_capabilities()
  local on_attach = function(client, bufnr)
    require('plugin.mod.lang.common').on_attach(client, bufnr)
  end

  rt.setup {
    tools = {
      -- how to execute terminal commands
      -- options right now: termopen / quickfix
      executor = require("rust-tools.executors").termopen,

      -- callback to execute once rust-analyzer is done initializing the workspace
      -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
      on_initialized = nil,

      -- 修改 Cargo.toml 后自动 reload workspace
      reload_workspace_from_cargo_toml = true,

      -- These apply to the default RustSetInlayHints command
      inlay_hints = {
        -- automatically set inlay hints (type hints)
        -- default: true
        auto = true,

        -- Only show inlay hints for the current line
        only_current_line = false,

        -- whether to show parameter hints with the inlay hints or not
        -- default: true
        show_parameter_hints = true,

        -- prefix for parameter hints
        -- default: "<-"
        parameter_hints_prefix = "<- ",

        -- prefix for all the other hints (type, chaining)
        -- default: "=>"
        other_hints_prefix = "=> ",

        -- whether to align to the length of the longest line in the file
        max_len_align = false,

        -- padding from the left if max_len_align is true
        max_len_align_padding = 1,

        -- whether to align to the extreme right or not
        right_align = false,

        -- padding from the right if right_align is true
        right_align_padding = 7,

        -- The color of the hints
        highlight = "Comment",
      },

      -- options same as lsp hover / vim.lsp.util.open_floating_preview()
      hover_actions = {
        -- the border that is used for the hover window
        -- see vim.api.nvim_open_win()
        border = {
          { "╭", "FloatBorder" },
          { "─", "FloatBorder" },
          { "╮", "FloatBorder" },
          { "│", "FloatBorder" },
          { "╯", "FloatBorder" },
          { "─", "FloatBorder" },
          { "╰", "FloatBorder" },
          { "│", "FloatBorder" },
        },

        -- Maximal width of the hover window. Nil means no max.
        max_width = nil,

        -- Maximal height of the hover window. Nil means no max.
        max_height = nil,

        -- whether the hover action window gets automatically focused
        -- default: false
        auto_focus = false,
      },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
      standalone = true,
      on_attach = on_attach,
      capabilities = capabilities,
    },

    -- -- debugging stuff
    -- dap = {
    --   adapter = {
    --     type = "executable",
    --     command = "lldb-vscode",
    --     name = "rt_lldb",
    --   },
    -- },
  }
end

function M.neorg()
  -- https://github.com/nvim-neorg/neorg
  local neorg = require("neorg")
  neorg.setup {
    load = {
      ["core.defaults"] = {},
      ["core.norg.qol.toc"] = {},
      ["core.norg.concealer"] = {},
      ["core.presenter"] = {
        config = {
          zen_mode = "zen-mode"
        }
      },
      ["core.norg.completion"] = {
        config = {
          engine = "nvim-cmp"
        }
      },
      ["core.integrations.nvim-cmp"] = {},
      ["core.export"] = {},

      --
      ["core.keybinds"] = {
        config = {
          hook = function(keybinds)
            keybinds.remap_event("norg", "n", "gtt", "core.norg.qol.todo_items.todo.task_cycle")
          end
        }
      }
    }
  }
end

function M.flutter()
  local ft = require("flutter-tools")
  local on_attach = function(client, bufnr)
    require('plugin.mod.lang.common').on_attach(client, bufnr)
  end
  local capabilities = require('plugin.mod.lang.common').cmp_capabilities()
  local U = require('core.utils')
  ft.setup {
    ui = {
      -- the border type to use for all floating windows, the same options/formats
      -- used for ":h nvim_open_win" e.g. "single" | "shadow" | {<table-of-eight-chars>}
      border = "single",
      -- This determines whether notifications are show with `vim.notify` or with the plugin's custom UI
      -- please note that this option is eventually going to be deprecated and users will need to
      -- depend on plugins like `nvim-notify` instead.
      notification_style = 'plugin'
    },
    decorations = {
      statusline = {
        -- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
        -- this will show the current version of the flutter app from the pubspec.yaml file
        app_version = true,
        -- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
        -- this will show the currently running device if an application was started with a specific
        -- device
        device = true,
      }
    },
    debugger = { -- integrate with nvim dap + install dart code debugger
      enabled = false,
      run_via_dap = false, -- use dap instead of a plenary job to run flutter apps
      -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
      -- see |:help dap.set_exception_breakpoints()| for more info
      exception_breakpoints = {},
      register_configurations = function(paths)
        require("dap").configurations.dart = {
          -- <put here config that you would find in .vscode/launch.json>
        }
      end,
    },
    fvm = false, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
    flutter_path = U.get_flutter_path(), -- <-- this takes priority over the lookup
    -- flutter_lookup_cmd = nil, -- example "dirname $(which flutter)" or "asdf where flutter"
    widget_guides = {
      enabled = true,
    },
    closing_tags = {
      highlight = "ErrorMsg", -- highlight for the closing tag
      prefix = ">", -- character to use for close tag e.g. > Widget
      enabled = true -- set to false to disable
    },
    dev_log = {
      enabled = true,
      open_cmd = "tabedit", -- command to use to open the log buffer
    },
    dev_tools = {
      autostart = false, -- autostart devtools server if not detected
      auto_open_browser = false, -- Automatically opens devtools in the browser
    },
    outline = {
      -- open_cmd = "30vnew", -- command to use to open the outline buffer
      open_cmd = "rightb 30vnew",
      auto_open = false -- if true this will open the outline automatically when it is first populated
    },
    lsp = {
      on_attach = on_attach,
      capabilities = capabilities,
      color = { -- show the derived colours for dart variables
        enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
        background = false, -- highlight the background
        foreground = false, -- highlight the foreground
        virtual_text = true, -- show the highlight using virtual text
        virtual_text_str = "■", -- the virtual text character to highlight
      },
      -- see the link below for details on each option:
      -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
      settings = {
        showTodos = true,
        completeFunctionCalls = true,
        analysisExcludedFolders = { "<path-to-flutter-sdk-packages>" },
        renameFilesWithClasses = "prompt", -- "always"
        enableSnippets = true,
      }
    }
  }
end

return M

