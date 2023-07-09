local M = {
  'nvim-treesitter/nvim-treesitter',
  build = function()
    local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    ts_update()
  end,
}


function M.config()
  local U = require('core.utils')
  -- 从 git 下载，而不是 curl
  require("nvim-treesitter.install").prefer_git = true
  -- 替换 github 为镜像地址
  for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
    config.install_info.url = config.install_info.url:gsub("https://github.com/", U.get_github_mirror())
  end

  local ts = require('nvim-treesitter.configs')
  ts.setup {
    sync_install = false,
    auto_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
      disable = {},
    },
    indent = {
      enable = true,
      disable = {},
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        node_incremental = '<CR>',
        scope_incremental = '<CR>',
        node_decremental = '<BS>',
      }
    },
    ensure_installed = {
      -- 
      "vim",
      "regex",
      "dockerfile",
      "lua",
      "sql",
      "python",
      "julia",
      "vhs",
      -- 
      "toml",
      "json",
      "yaml",
      "proto",
      -- 
      "norg",
      "markdown",
      "markdown_inline",
      -- 
      "html",
      "css",
      "javascript",
      "typescript",
      "svelte",
      --
      "java",
      "kotlin",
      "rust",
      "go",
      "gomod",
      "dart",
      "zig",
      "v",
    },
    autotag = {
      enable = true,
    },
  }
end

return M
