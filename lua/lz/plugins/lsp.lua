-- [nfnl] fnl/lz/plugins/lsp.fnl
local _local_1_ = require("core.utils")
local list_includes = _local_1_["list_includes"]
local get_mason_path = _local_1_["get_mason_path"]
local lsp_server_package_path = _local_1_["lsp_server_package_path"]
local lsp_with_server = _local_1_["lsp_with_server"]
local lsp_on_attach = _local_1_["lsp_on_attach"]
local lsp_capabilities = _local_1_["lsp_capabilities"]
local function create_LuaLibsReload()
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
  return (not workspace_path or (nvim_config_path == workspace_path:sub(1, #nvim_config_path)) or not (vim.uv.fs_stat((workspace_path .. "/.luarc.json")) or vim.uv.fs_stat((workspace_path .. "/.luarc.jsonc"))))
end
local function _6_(client)
  print("lua_ls load nvim lua libs.")
  vim.g.nvim_lua_libs = (vim.g.nvim_lua_libs or {vim.env.VIMRUNTIME, "${3rd}/luv/library"})
  client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {codeLens = {enable = false}, runtime = {version = "LuaJIT"}, workspace = {library = vim.g.nvim_lua_libs, checkThirdParty = false}})
  return create_LuaLibsReload()
end
lua_conditional_settings = {{match = _5_, config = _6_}}
local function _7_()
  vim.diagnostic.config({severity_sort = true, virtual_lines = {current_line = true}, virtual_text = false})
  vim.lsp.config("*", {root_markers = {".git"}, capabilities = lsp_capabilities()})
  local function _8_(_241)
    return lsp_on_attach(assert(vim.lsp.get_client_by_id(_241.data.client_id)), _241.buf)
  end
  vim.api.nvim_create_autocmd("LspAttach", {callback = _8_})
  local function get_nvim_config_path()
    local path = vim.fn.stdpath("config")
    local path1
    do
      local _9_ = type(path)
      if (_9_ == "table") then
        path1 = path[1]
      else
        local _ = _9_
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
  local configs = require("lspconfig.configs")
  local function _12_(_241)
    return vim.fs.root(_241, {"flix.toml", ".git"})
  end
  configs.flix = {default_config = {cmd = {"flix", "lsp"}, filetypes = {"flix"}, root_dir = _12_}}
  local function _13_(_241)
    return vim.fs.root(_241, {"module.ens", ".git"})
  end
  configs.neut = {default_config = {cmd = {"neut", "lsp"}, filetypes = {"neut"}, root_dir = _13_}}
  local lspconfig = require("lspconfig")
  local function _14_(client)
    local nvim_config_path = get_nvim_config_path()
    print("lua_ls nvim config path:", nvim_config_path)
    local workspace_path = get_workspace_path(client)
    print("lua_ls workspace path:", workspace_path)
    client.config.settings.Lua = {codeLens = {enable = true}, completion = {callSnippet = "Replace"}, telemetry = {enable = false}, workspace = {library = {}, checkThirdParty = false}}
    for _, s in ipairs(lua_conditional_settings) do
      if s.match(nvim_config_path, workspace_path) then
        s.config(client)
        break
      else
      end
    end
    return print("lua_ls settings:", vim.inspect(client.config.settings.Lua))
  end
  lspconfig.lua_ls.setup({on_init = _14_})
  lspconfig.kulala_ls.setup({})
  local function _16_(_241)
    return lspconfig.dockerls.setup({cmd = {_241, "--stdio"}})
  end
  lsp_with_server("docker-langserver", _16_)
  lspconfig.jsonls.setup({})
  lspconfig.taplo.setup({})
  lspconfig.lemminx.setup({})
  lspconfig.yamlls.setup({})
  lspconfig.nushell.setup({})
  lspconfig.powershell_es.setup({bundle_path = lsp_server_package_path("powershell-editor-services")})
  lspconfig.vtsls.setup({})
  lspconfig.html.setup({})
  local function _17_(_241)
    return lspconfig.htmx.setup({cmd = {_241}})
  end
  lsp_with_server("htmx-lsp", _17_)
  local function _18_(_241)
    local function _19_(fname)
      local patterns = {"tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts"}
      return vim.fs.root(fname, patterns)
    end
    return lspconfig.tailwindcss.setup({cmd = {_241, "--stdio"}, root_dir = _19_})
  end
  lsp_with_server("tailwindcss-language-server", _18_)
  lspconfig.svelte.setup({})
  local function _20_(_241)
    local function _21_(fname)
      local patterns = {"project.clj", "deps.edn", "build.boot", "shadow-cljs.edn", "bb.edn"}
      return vim.fs.root(fname, patterns)
    end
    return lspconfig.clojure_lsp.setup({cmd = {_241}, root_dir = _21_})
  end
  lsp_with_server("clojure-lsp", _20_)
  lspconfig.crystalline.setup({})
  local function _22_(fname)
    local patterns = {"pubspec.yaml", ".git"}
    return vim.fs.root(fname, patterns)
  end
  lspconfig.dartls.setup({root_dir = _22_})
  local function _23_(_241)
    return lspconfig.elixirls.setup({cmd = {_241}})
  end
  lsp_with_server("elixir-ls", _23_)
  lspconfig.fennel_ls.setup({})
  lspconfig.flix.setup({})
  local function _24_(fname)
    local patterns = {"gleam.toml", ".git"}
    return vim.fs.root(fname, patterns)
  end
  lspconfig.gleam.setup({root_dir = _24_})
  lspconfig.gradle_ls.setup({})
  lspconfig.gopls.setup({})
  local function _25_(new_config, _)
    local _26_ = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
    local and_27_ = (nil ~= _26_)
    if and_27_ then
      local julia_bin = _26_
      local _30_
      do
        local t_29_ = vim.uv.fs_stat(julia_bin)
        if (nil ~= t_29_) then
          t_29_ = t_29_.type
        else
        end
        _30_ = t_29_
      end
      and_27_ = (_30_ == "file")
    end
    if and_27_ then
      local julia_bin = _26_
      new_config.cmd[1] = julia_bin
      return nil
    else
      return nil
    end
  end
  lspconfig.julials.setup({on_new_config = _25_})
  lspconfig.koka.setup({})
  lspconfig.neut.setup({})
  lspconfig.nim_langserver.setup({})
  lspconfig.ocamllsp.setup({})
  lspconfig.ols.setup({})
  lspconfig.racket_langserver.setup({})
  lspconfig.raku_navigator.setup({cmd = {"raku-navigator", "--stdio"}})
  lspconfig.roc_ls.setup({})
  lspconfig.sourcekit.setup({})
  lspconfig.vls.setup({})
  return lspconfig.zls.setup({settings = {zls = {enable_snippets = true, highlight_global_var_declarations = true, enable_argument_placeholders = false}}})
end
return {{"neovim/nvim-lspconfig", cmd = {"LspInfo", "LspStart", "LspLog"}, dependencies = {{"deathbeam/lspecho.nvim", opts = {}}}, config = _7_}, {"williamboman/mason.nvim", cmd = "Mason", opts = {install_root_dir = get_mason_path(), PATH = "prepend", ui = {backdrop = vim.g.zz.backdrop}}}}
