-- [nfnl] fnl/lz/plugins/lsp.fnl
local _local_1_ = require("core.utils")
local tbl_includes = _local_1_["tbl_includes"]
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
    if ((force ~= "force") and tbl_includes(old_libs, new_libs)) then
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
  local function _8_(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufid = args.buf
    return lsp_on_attach(client, bufid)
  end
  vim.api.nvim_create_autocmd("LspAttach", {callback = _8_})
  local lspconfig = require("lspconfig")
  local function _9_(client)
    local nvim_config_path
    do
      local path = vim.fn.stdpath("config")
      local path1
      if ("table" == type(path)) then
        path1 = path[1]
      else
        path1 = tostring(path)
      end
      nvim_config_path = vim.uv.fs_realpath(path1)
    end
    print("lua_ls nvim config path:", nvim_config_path)
    local workspace_path
    if client.workspace_folders then
      workspace_path = vim.uv.fs_realpath(client.workspace_folders[1].name)
    else
      workspace_path = nil
    end
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
  lspconfig.lua_ls.setup({on_init = _9_})
  lspconfig.kulala_ls.setup({})
  local function _13_(server_path)
    return lspconfig.dockerls.setup({cmd = {server_path, "--stdio"}})
  end
  lsp_with_server("docker-langserver", _13_)
  lspconfig.jsonls.setup({})
  lspconfig.taplo.setup({})
  lspconfig.lemminx.setup({})
  lspconfig.yamlls.setup({})
  lspconfig.nushell.setup({})
  lspconfig.powershell_es.setup({bundle_path = lsp_server_package_path("powershell-editor-services")})
  lspconfig.ts_ls.setup({})
  lspconfig.html.setup({})
  local function _14_(server_path)
    return lspconfig.htmx.setup({cmd = {server_path}})
  end
  lsp_with_server("htmx-lsp", _14_)
  local function _15_(server_path)
    local function _16_(fname)
      local patterns = {"tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts"}
      return vim.fs.root(fname, patterns)
    end
    return lspconfig.tailwindcss.setup({cmd = {server_path, "--stdio"}, root_dir = _16_})
  end
  lsp_with_server("tailwindcss-language-server", _15_)
  lspconfig.svelte.setup({})
  local function _17_(server_path)
    local function _18_(fname)
      local patterns = {"project.clj", "deps.edn", "build.boot", "shadow-cljs.edn", "bb.edn"}
      return vim.fs.root(fname, patterns)
    end
    return lspconfig.clojure_lsp.setup({cmd = {server_path}, root_dir = _18_})
  end
  lsp_with_server("clojure-lsp", _17_)
  lspconfig.crystalline.setup({})
  local function _19_(fname)
    local patterns = {"pubspec.yaml", ".git"}
    return vim.fs.root(fname, patterns)
  end
  lspconfig.dartls.setup({root_dir = _19_})
  local function _20_(server_path)
    return lspconfig.elixirls.setup({cmd = {server_path}})
  end
  lsp_with_server("elixir-ls", _20_)
  lspconfig.fennel_ls.setup({})
  local function _21_(fname)
    local patterns = {"gleam.toml", ".git"}
    return vim.fs.root(fname, patterns)
  end
  lspconfig.gleam.setup({root_dir = _21_})
  lspconfig.gradle_ls.setup({})
  lspconfig.gopls.setup({})
  local function _22_(new_config, _)
    local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
    local julia_found
    local _24_
    do
      local t_23_ = vim.uv.fs_stat(julia)
      if (nil ~= t_23_) then
        t_23_ = t_23_.type
      else
      end
      _24_ = t_23_
    end
    julia_found = (_24_ == "file")
    if julia_found then
      new_config.cmd[1] = julia
      return nil
    else
      return nil
    end
  end
  lspconfig.julials.setup({on_new_config = _22_})
  lspconfig.koka.setup({})
  lspconfig.nim_langserver.setup({})
  lspconfig.ocamllsp.setup({})
  lspconfig.ols.setup({})
  lspconfig.racket_langserver.setup({})
  lspconfig.raku_navigator.setup({cmd = {"raku-navigator", "--stdio"}})
  lspconfig.sourcekit.setup({})
  lspconfig.vls.setup({})
  return lspconfig.zls.setup({settings = {zls = {enable_snippets = true, highlight_global_var_declarations = true, enable_argument_placeholders = false}}})
end
return {{"neovim/nvim-lspconfig", cmd = {"LspInfo", "LspStart", "LspLog"}, dependencies = {{"deathbeam/lspecho.nvim", opts = {}}}, config = _7_}, {"williamboman/mason.nvim", cmd = "Mason", opts = {install_root_dir = get_mason_path(), PATH = "prepend", ui = {backdrop = vim.g.zz.backdrop}}}}
