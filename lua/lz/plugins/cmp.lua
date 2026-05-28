-- [nfnl] fnl/lz/plugins/cmp.fnl
local completion_list_opts = {selection = {preselect = true, auto_insert = false}}
local common_keymaps = {["<Tab>"] = {"accept"}, ["<M-j>"] = {"select_next"}, ["<M-k>"] = {"select_prev"}, ["<C-c>"] = {"hide", "fallback"}}
local function _1_()
  vim.opt.autocomplete = false
  return nil
end
return {"saghen/blink.cmp", version = "1.*", event = {"InsertEnter", "CmdlineEnter"}, dependencies = {{"rafamadriz/friendly-snippets"}, {"mikavilpas/blink-ripgrep.nvim"}}, init = _1_, opts = {appearance = {nerd_font_variant = "mono"}, signature = {enabled = true}, fuzzy = {implementation = "prefer_rust_with_warning"}, sources = {default = {"lsp", "path", "snippets", "buffer", "ripgrep"}, providers = {ripgrep = {module = "blink-ripgrep", name = "Ripgrep", score_offset = -10, opts = {}}}}, completion = {list = completion_list_opts}, keymap = vim.tbl_deep_extend("force", common_keymaps, {preset = "super-tab", ["<M-Space>"] = {"show", "show_documentation", "hide_documentation"}, ["<C-u>"] = {"scroll_documentation_up", "fallback"}, ["<C-d>"] = {"scroll_documentation_down", "fallback"}, ["<C-k>"] = {"fallback"}}), cmdline = {completion = {list = completion_list_opts, menu = {auto_show = true}}, keymap = vim.tbl_deep_extend("force", common_keymaps, {preset = "none"})}}, opts_extend = {"sources.default"}}
