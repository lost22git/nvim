local M = {}

function M.version_ge(version_string)
  local current = vim.version()
  local min = vim.version.parse(version_string)
  assert(min ~= nil)
  return vim.version.cmp(current, min) >= 0
end

function M.on_gui()
  return M.on_neovide() or M.on_fvim() or M.on_vscode()
end

function M.on_vscode()
  return vim.g.vscode or false
end

function M.on_neovide()
  return vim.g.neovide or false
end

function M.on_fvim()
  return vim.g.fvim_loaded or false
end

function M.on_wsl()
  return vim.fn.has("wsl") == 1
end

function M.on_win()
  return vim.fn.has("win32") == 1
end

function M.on_mac()
  return vim.fn.has("macunix") == 1
end

function M.get_github_mirror()
  -- return "https://hub.fastgit.xyz/"
  return "https://www.github.com/"
end

function M.get_name_and_ext(path)
  path = path or ""
  return path:match("^.+[\\/]([^\\/]+)(%.%w+)$")
end

function M.get_buf_lsp_clients_name()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local names = vim.tbl_map(function(cli)
    return cli.name
  end, clients)
  return table.concat(names, "/")
end

function M.get_data_path()
  return vim.fn.resolve(vim.fn.stdpath("data"))
end

function M.get_config_path()
  return vim.fn.resolve(vim.fn.stdpath("config"))
end

function M.get_mason_path()
  return M.get_data_path() .. "/mason"
end

local lsp_server_bin_dir = M.get_mason_path() .. "/bin/"
local lsp_server_package_dir = M.get_mason_path() .. "/packages/"

function M.lsp_server_found(name, fn)
  local path = M.get_lsp_server_path(name)
  if path ~= "" then
    fn(path)
  end
end

function M.get_lsp_server_path(name)
  -- 查找顺序：
  -- 1. mason 目录
  local path = M.on_win() and (lsp_server_bin_dir .. name .. ".cmd") or (lsp_server_bin_dir .. name)
  if vim.fn.executable(path) == 1 then
    return path
  end

  -- 2. 环境变量 PATH
  path = vim.fn.exepath(name) or ""
  -- windows: 如果 path 没有扩展名，添加 .cmd
  if path ~= "" and M.on_win() and ({ M.get_name_and_ext(path) })[2] == nil then
    path = path .. ".cmd"
  end
  return path
end

function M.get_lsp_server_package_path(name)
  return lsp_server_package_dir .. name
end

function M.system_open(path)
  if M.on_mac() then
    vim.notify("mac system_open path=" .. path, vim.log.levels.INFO)
    vim.fn.jobstart("open -g '" .. path .. "' &", { detach = true })
  elseif M.on_win() then
    vim.notify("win system_open path=" .. path, vim.log.levels.INFO)
    vim.fn.jobstart("explorer.exe '" .. path .. "'")
  else
    vim.notify("linux system_open path=" .. path, vim.log.levels.INFO)
    vim.fn.jobstart("xdg-open '" .. path .. "' &", { detach = true })
  end
end

function M.get_lualine_hl_group(section, mode)
  local m = mode or vim.fn.mode()
  local k = string.sub(m, 1, 2)
  k = string.byte(k) == 22 and "v" or k -- Ctrl-V asciicode => 22
  k = string.lower(k)
  local kv = {
    n = "normal",
    i = "insert",
    v = "visual",
    c = "command",
    t = "terminal",
    r = "replace",
  }
  local v = kv[k] or "normal"
  local hl_group = string.format("lualine_%s_%s", section, v)
  -- print(string.format("mode=>%s k=>%s hl_group=>%s", m, k, hl_group))
  return hl_group
end

function M.get_flutter_path()
  if M.on_win() then
    return vim.fn.exepath("flutter") .. ".bat"
  else
    return vim.fn.exepath("flutter")
  end
end

function M.lsp_cmp_capabilities()
  return require("cmp_nvim_lsp").default_capabilities()
end

function M.lsp_on_attach(client, bufnr)
  require("core.maps").lsp(bufnr)
  M.lsp_format_on_save(client, bufnr)
end

function M.lsp_format_on_save(client, bufnr)
  local augroup_format = vim.api.nvim_create_augroup("lsp_format_on_save", {})
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup_format,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          bufnr = bufnr,
          timeout_ms = 1000,
          -- async = true,
        })
      end,
    })
  end
end

return M
