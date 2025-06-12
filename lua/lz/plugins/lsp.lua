-- [nfnl] fnl/lz/plugins/lsp.fnl
local _local_1_ = require("core.utils")
local list_includes = _local_1_["list_includes"]
local get_mason_path = _local_1_["get_mason_path"]
local lsp_on_attach = _local_1_["lsp_on_attach"]
local lsp_capabilities = _local_1_["lsp_capabilities"]
local function create_usercmd_LuaLibsReload()
  local function callback(input)
    local libs = {vim = {vim.env.VIMRUNTIME, "${3rd}/luv/library"}, all = {"${3rd}/luv/library", unpack(vim.api.nvim_get_runtime_file("", true))}}
    local _local_2_ = vim.fn.split(input.fargs[1], "-", false)
    local mode = _local_2_[1]
    local force = _local_2_[2]
    local new_libs, old_libs = libs[mode], vim.g.nvim_lua_libs
    if ((force ~= "force") and list_includes(old_libs, new_libs)) then
      return vim.notify("[LuaLibsReload] libs have already loaded.")
    else
      vim.g.nvim_lua_libs = new_libs
      return vim.cmd("LspRestart lua_ls")
    end
  end
  local function _4_()
    return {"vim", "all", "vim-force", "all-force"}
  end
  return vim.api.nvim_create_user_command("LuaLibsReload", callback, {nargs = 1, complete = _4_})
end
local lua_conditional_settings
local function _5_(nvim_config_path, workspace_path)
  return (not workspace_path or vim.startswith(workspace_path, nvim_config_path) or not (vim.uv.fs_stat((workspace_path .. "/.luarc.json")) or vim.uv.fs_stat((workspace_path .. "/.luarc.jsonc"))))
end
local function _6_(client)
  print("lua_ls load nvim lua libs.")
  vim.g.nvim_lua_libs = (vim.g.nvim_lua_libs or {vim.env.VIMRUNTIME, "${3rd}/luv/library"})
  client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {codeLens = {enable = false}, runtime = {version = "LuaJIT"}, workspace = {library = vim.g.nvim_lua_libs, checkThirdParty = false}})
  return create_usercmd_LuaLibsReload()
end
lua_conditional_settings = {{match = _5_, config = _6_}}
local function get_nvim_config_path()
  local path = vim.fn.stdpath("config")
  local path1
  do
    local _7_ = type(path)
    if (_7_ == "table") then
      path1 = path[1]
    else
      local _ = _7_
      path1 = tostring(path)
    end
  end
  return vim.uv.fs_realpath(path1)
end
local function get_workspace_path(client)
  if client.workspace_folders then
    return vim.uv.fs_realpath(client.workspace_folders[1].name)
  else
    return nil
  end
end
local function _10_()
  vim.diagnostic.config({severity_sort = true, virtual_lines = {current_line = true}, virtual_text = false})
  vim.lsp.config("*", {root_markers = {".git"}, capabilities = lsp_capabilities()})
  local function _11_(_241)
    return lsp_on_attach(assert(vim.lsp.get_client_by_id(_241.data.client_id)), _241.buf)
  end
  vim.api.nvim_create_autocmd("LspAttach", {callback = _11_})
  local function _12_(client)
    local nvim_config_path = get_nvim_config_path()
    print("lua_ls nvim config path:", nvim_config_path)
    local workspace_path = get_workspace_path(client)
    print("lua_ls workspace path:", workspace_path)
    for _, s in ipairs(lua_conditional_settings) do
      if s.match(nvim_config_path, workspace_path) then
        s.config(client)
        break
      else
      end
    end
    return print("lua_ls settings:", vim.inspect(client.config.settings.Lua))
  end
  vim.lsp.config("lua_ls", {settings = {Lua = {codeLens = {enable = true}, completion = {callSnippet = "Replace"}, telemetry = {enable = false}, workspace = {library = {}, checkThirdParty = false}}}, on_init = _12_})
  vim.lsp.config("flix", {cmd = {"flix", "lsp"}, filetypes = {"flix"}, root_markers = {"flix.toml"}})
  vim.lsp.config("raku_navigator", {cmd = {"raku-navigator", "--stdio"}})
  vim.lsp.config("tailwindcss", {root_markers = {"tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts"}})
  vim.lsp.config("zls", {settings = {zls = {enable_snippets = true, highlight_global_var_declarations = true, enable_argument_placeholders = false}}})
  return vim.lsp.enable({"fennel_ls", "marksman", "kulala_ls", "dockerls", "nushell", "powershell_es", "html", "htmx", "svelte", "vtsls", "clojure_lsp", "crystalline", "dartls", "elixirls", "gleam", "gradle_ls", "gopls", "julials", "koka", "nim_langserver", "ocamllsp", "ols", "racket_langserver", "roc_ls", "sourcekit", "v-analyzer"})
end
return {{"neovim/nvim-lspconfig", cmd = {"LspInfo", "LspStart", "LspLog"}, dependencies = {{"deathbeam/lspecho.nvim", opts = {}}}, config = _10_}, {"williamboman/mason.nvim", cmd = "Mason", opts = {install_root_dir = get_mason_path(), PATH = "prepend", ui = {backdrop = vim.g.zz.backdrop}}}}
