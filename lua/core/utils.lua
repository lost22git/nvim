local M = {}

function M.version_ge(version_string)
  local current = vim.version()
  local min = vim.version.parse(version_string)
  assert(min ~= nil)
  return vim.version.cmp(current, min) >= 0
end

function M.is_gui()
  return M.is_neovide() or M.is_fvim() or M.is_vscode()
end

function M.is_vscode()
  return vim.g.vscode or false
end

function M.is_neovide()
  return vim.g.neovide or false
end

function M.is_fvim()
  return vim.g.fvim_loaded or false
end

function M.is_wsl()
  return vim.fn.has 'wsl' == 1
end

function M.is_win()
  return vim.fn.has 'win32' == 1
end

function M.is_mac()
  return vim.fn.has 'macunix' == 1
end

function M.get_github_mirror()
  -- return "https://hub.fastgit.xyz/"
  return "https://www.github.com/"
end

function M.get_name_and_ext(path)
  path = path or ''
  return path:match("^.+[\\/]([^\\/]+)(%.%w+)$")
end

function M.get_buf_lsp_clients_name()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  local names = vim.tbl_map(function(cli) return cli.name end, clients)
  return table.concat(names, '/')
end

function M.get_data_path()
  return vim.fn.resolve(vim.fn.stdpath('data'))
end

function M.get_config_path()
  return vim.fn.resolve(vim.fn.stdpath('config'))
end

function M.get_mason_path()
  return M.get_data_path() .. '/mason'
end

local lsp_server_bin_dir = M.get_mason_path() .. '/bin/'
local lsp_server_package_dir = M.get_mason_path() .. '/packages/'

function M.get_lsp_server_path(name)
  -- 查找顺序：
  -- 1. mason 目录
  -- 2. 环境变量 PATH
  local path = ''
  if M.is_win() then
    path = lsp_server_bin_dir .. name .. '.cmd'
  else
    path = lsp_server_bin_dir .. name
  end
  if vim.fn.executable(path) ~= 1 then
    path = vim.fn.exepath(name) or ''
  end
  -- windows 下如果 path 没有后缀，添加 .cmd 后缀
  if path ~= '' and M.is_win() and ({ M.get_name_and_ext(path) })[2] == nil then
    path = path .. '.cmd'
  end

  return path
end

function M.get_lsp_server_package_path(name)
  return lsp_server_package_dir .. name
end

function M.system_open(path)
  if M.is_mac() then
    vim.notify('mac system_open path=' .. path, vim.log.levels.INFO)
    vim.fn.jobstart("open -g '" .. path .. "' &", { detach = true })
  elseif M.is_win() then
    vim.notify('win system_open path=' .. path, vim.log.levels.INFO)
    vim.fn.jobstart("explorer.exe '" .. path .. "'")
  else
    vim.notify('linux system_open path=' .. path, vim.log.levels.INFO)
    vim.fn.jobstart("xdg-open '" .. path .. "' &", { detach = true })
  end
end

function M.get_lualine_hl_group(section, mode)
  local m = mode or vim.fn.mode()
  local k = string.sub(m, 1, 2)
  k = string.byte(k) == 22 and "v" or k -- Ctrl-V asciicode => 22
  k = string.lower(k)
  local kv = {
    n = 'normal',
    i = 'insert',
    v = 'visual',
    c = 'command',
    t = 'terminal',
    r = 'replace',
  }
  local v = kv[k] or "normal"
  local hl_group = string.format("lualine_%s_%s", section, v)
  -- print(string.format("mode=>%s k=>%s hl_group=>%s", m, k, hl_group))
  return hl_group
end

function M.get_flutter_path()
  if M.is_win() then
    return vim.fn.exepath('flutter') .. '.bat'
  else
    return vim.fn.exepath('flutter')
  end
end

return M
