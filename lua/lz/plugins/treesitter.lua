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
        files = { 'src/parser.c', 'src/scanner.c' }, -- note that some parsers also require src/scanner.c or src/scanner.cc
      },
    }
    ---@diagnostic disable-next-line: inject-field
    parser_config.nu = {
      filetype = 'nu',
      install_info = {
        url = helix_treesitter_parsers_sources .. 'nu',
        files = { 'src/parser.c' }, -- note that some parsers also require src/scanner.c or src/scanner.cc
      },
    }
  end
end

local M = {
  'nvim-treesitter/nvim-treesitter',
  build = function()
    local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    ts_update()
  end,
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    sync_install = false,
    auto_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby', 'crystal' },
      disable = {},
    },
    indent = {
      enable = true,
      disable = { 'ruby', 'crystal' },
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
    local U = require('core.utils')

    -- 替换 github 为镜像地址
    require('nvim-treesitter.install').prefer_git = true
    for _, config in pairs(require('nvim-treesitter.parsers').get_parser_configs()) do
      config.install_info.url = config.install_info.url:gsub('https://github.com/', U.get_github_mirror())
    end

    use_helix_source()

    vim.treesitter.language.register('ruby', { 'ruby', 'crystal' })

    require('nvim-treesitter.configs').setup(opts)
  end,
}

return {
  M,
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function() require('nvim-treesitter.configs').setup({}) end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    cmd = { 'TSContextEnable' },
    opts = {},
  },
}
