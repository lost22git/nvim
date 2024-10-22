local M = {
  'nvim-treesitter/nvim-treesitter',
  build = function()
    local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    ts_update()
  end,
  dependencies = {
    -- { "nushell/tree-sitter-nu" },
  },
  event = { "BufReadPost", "BufNewFile" },
}


function M.config()
  local U = require('core.utils')
  -- 从 git 下载，而不是 curl
  require("nvim-treesitter.install").prefer_git = true

  -- 替换 github 为镜像地址
  for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
    config.install_info.url = config.install_info.url:gsub("https://github.com/", U.get_github_mirror())
  end

  -------------------------------
  -- helix treesitter parsers  --
  -------------------------------
  local helix_runtimepath = vim.env.HELIX_RUNTIMEPATH
  if vim.fn.exists(helix_runtimepath) then
    -------------
    -- queries --
    -------------
    -- append helix_runtimepath to help search `queries/*/*.scm`
    vim.opt.runtimepath:append(',' .. helix_runtimepath)

    -------------
    -- parsers --
    -------------
    local helix_treesitter_parsers_sources = helix_runtimepath .. 'grammars/sources/'
    local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    -- koka lang
    ---@diagnostic disable-next-line: inject-field
    parser_config.koka = {
      filetype = 'koka',
      install_info = {
        url = helix_treesitter_parsers_sources .. 'koka',
        files = { 'src/parser.c', 'src/scanner.c' }, -- note that some parsers also require src/scanner.c or src/scanner.cc
      },
    }
    -- nushell
    ---@diagnostic disable-next-line: inject-field
    parser_config.nu = {
      filetype = 'nu',
      install_info = {
        url = helix_treesitter_parsers_sources .. 'nu',
        files = { 'src/parser.c' }, -- note that some parsers also require src/scanner.c or src/scanner.cc
      },
    }
  end

  -----------------------------------
  -- register parser for filetypes --
  -----------------------------------
  vim.treesitter.language.register('ruby', { 'ruby', 'crystal' })

  ------------------------------
  -- nvim treesitter parsers  --
  ------------------------------

  local ts = require('nvim-treesitter.configs')
  ---@diagnostic disable-next-line: missing-fields
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
      "rust",
      "go",
      "gomod",
      "dart",
      "zig",
      "v",
      "nim",
      "gleam",
    },
    autotag = {
      enable = true,
    },
  }
end

return M
