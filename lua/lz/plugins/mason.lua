local M = {
  "williamboman/mason.nvim",
  enabled = not vim.g.vscode,
  cmd = { "Mason" },
}

function M.config()
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

return M
