-- [nfnl] fnl/lz/plugins/ts.fnl
local function add_custom_sources()
  vim.treesitter.language.register("crystal", {"cr"})
  local function _1_()
    local parsers = require("nvim-treesitter.parsers")
    parsers.crystal = {install_info = {url = "https://github.com/crystal-lang-tools/tree-sitter-crystal", branch = "main", queries = "queries/nvim", generate = false, generate_from_json = false}}
    return nil
  end
  return vim.api.nvim_create_autocmd("User", {desc = "[TS] perform actions after :TSUpdate", pattern = "TSUpdate", callback = _1_})
end
local function install_langs()
  return require("nvim-treesitter").install({"bash", "lua", "fennel", "regex", "vim", "vimdoc", "markdown", "markdown_inline", "dockerfile", "http", "just", "sql", "json", "toml", "xml", "yaml", "css", "html", "javascript", "typescript", "commonlisp", "scheme", "clojure", "crystal", "go", "gomod", "java"})
end
local function _2_()
  add_custom_sources()
  return install_langs()
end
return {{"nvim-treesitter/nvim-treesitter-context", cmd = "TSContext", opts = {}}, {"nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate", dependencies = {"nvim-treesitter/nvim-treesitter-textobjects"}, config = _2_, lazy = false}}
