local function use_helix_source()
  local helix_runtimepath = vim.env.HELIX_RUNTIMEPATH
  if helix_runtimepath and vim.fn.exists(helix_runtimepath) then
    -- queries --
    -- append helix_runtimepath to help search `queries/*/*.scm`
    vim.opt.runtimepath:append(',' .. helix_runtimepath)

    -- parsers --
    local helix_treesitter_parsers_sources = helix_runtimepath .. 'grammars/sources/'
    local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    ---@diagnostic disable-next-line: inject-field
    parser_config.koka = {
      filetype = 'koka',
      install_info = {
        url = helix_treesitter_parsers_sources .. 'koka',
        files = { 'src/parser.c', 'src/scanner.c' },
      },
    }
    ---@diagnostic disable-next-line: inject-field
    parser_config.nu = {
      filetype = 'nu',
      install_info = {
        url = helix_treesitter_parsers_sources .. 'nu',
        files = { 'src/parser.c' },
      },
    }
  end
end

local function use_custom_source()
  -- parsers --
  local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
  ---@diagnostic disable-next-line: inject-field
  parser_config.crystal = {
    filetype = 'crystal',
    install_info = {
      url = 'https://github.com/crystal-lang-tools/tree-sitter-crystal',
      branch = 'main',
      files = { 'src/parser.c', 'src/scanner.c' },
    },
  }
end

local M = {
  'nvim-treesitter/nvim-treesitter',
  build = function()
    local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    ts_update()
  end,
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
  },
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    sync_install = false,
    auto_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
      disable = {},
    },
    indent = {
      enable = true,
      disable = { 'ruby' },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        node_incremental = '<CR>',
        node_decremental = '<BS>',
      },
    },
    autotag = { enable = true },
    ensure_installed = {
      --
      'lua',
      'vim',
      'vimdoc',
      'regex',
      'bash',
      --
      'dockerfile',
      'just',
      'sql',
      'http',
      'hurl',
      --
      'json',
      'xml',
      'toml',
      'yaml',
      --
      'markdown',
      'markdown_inline',
      --
      'html',
      'css',
      'javascript',
      'typescript',
      --
      'clojure',
      'gleam',
      'java',
      'zig',
      'nim',
      'ruby',
      'rust',
      'go',
      'gomod',
      'dart',
    },
  },
  config = function(_, opts)
    -- 替换 github 为镜像地址
    require('nvim-treesitter.install').prefer_git = true
    for _, config in pairs(require('nvim-treesitter.parsers').get_parser_configs()) do
      config.install_info.url =
        config.install_info.url:gsub('https://github.com/', require('core.utils').get_github_mirror())
    end

    use_helix_source()
    use_custom_source()

    -- vim.treesitter.language.register('ruby', { 'ruby', 'crystal' })

    require('nvim-treesitter.configs').setup(opts)
  end,
}

return {
  M,
  {
    'nvim-treesitter/nvim-treesitter-context',
    cmd = { 'TSContextEnable' },
    opts = {},
  },
}
