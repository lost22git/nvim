-- [nfnl] fnl/lz/plugins/ts.fnl
local function use_helix_source()
  local rtp = vim.env.HELIX_RUNTIMEPATH
  if (rtp and vim.fn.exists(rtp)) then
    vim.opt.runtimepath:append(rtp)
    local parser_source = (rtp .. "/grammars/sources/")
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.koka = {filetype = "koka", install_info = {url = (parser_source .. "koka"), files = {"src/parser.c", "src/scanner.c"}}}
    parser_config.nu = {filetype = "nu", install_info = {url = (parser_source .. "nu"), files = {"src/parser.c"}}}
    return nil
  else
    return nil
  end
end
local function use_custom_source()
  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  parser_config.crystal = {filetype = "crystal", install_info = {url = "https://github.com/crystal-lang-tools/tree-sitter-crystal", branch = "main", files = {"src/parser.c", "src/scanner.c"}}}
  return nil
end
local function define_fold_module()
  local function _2_()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    return nil
  end
  local function _3_()
    vim.opt_local.foldmethod = vim.go.foldmethod
    vim.opt_local.foldexpr = vim.go.foldexpr
    return nil
  end
  local function _4_()
    return true
  end
  return require("nvim-treesitter").define_modules({fold = {attach = _2_, detach = _3_, is_supported = _4_}})
end
local function _5_()
  local _let_6_ = require("nvim-treesitter.install")
  local update = _let_6_["update"]
  local ts_update = update({with_sync = true})
  return ts_update()
end
local function _7_(_, opts)
  use_helix_source()
  use_custom_source()
  define_fold_module()
  return require("nvim-treesitter.configs").setup(opts)
end
return {{"nvim-treesitter/nvim-treesitter-context", dependencies = {"nvim-treesitter/nvim-treesitter"}, cmd = "TSContextEnable", opts = {}}, {"nvim-treesitter/nvim-treesitter", build = _5_, dependencies = {"nvim-treesitter/nvim-treesitter-textobjects"}, opts = {highlight = {enable = true, additional_vim_regex_highlighting = {"ruby"}, disable = {}}, indent = {enable = true, disable = {"ruby"}}, incremental_selection = {enable = true, disable = {"vim"}, keymaps = {init_selection = "<CR>", node_incremental = "<CR>", node_decremental = "<BS>"}}, autotag = {enable = true}, fold = {enable = false}, ensure_installed = {"bash", "lua", "regex", "vim", "vimdoc", "markdown", "markdown_inline", "dockerfile", "http", "hurl", "just", "sql", "json", "toml", "xml", "yaml", "css", "html", "javascript", "typescript", "clojure", "crystal", "go", "gomod", "java", "nim", "rust", "zig"}, auto_install = false, sync_install = false}, config = _7_, lazy = false}}
