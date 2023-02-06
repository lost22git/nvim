local U = require('core.utils')
local uv, api = vim.loop, vim.api

local config_path = U.get_config_path()
local mods_dir = config_path .. '/lua/plugin/mod'

local data_path = U.get_data_path()
local data_dir = string.format('%s/site/', data_path)
local packer_dir = data_dir .. 'pack/packer/opt/packer.nvim'
local packer_compiled = data_dir .. 'lua/packer_compiled.lua'

local packer_conf = {
  compile_path = packer_compiled,
  disable_commands = true,
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'single' }
    end,
    working_sym = "ﲊ",
    error_sym = "✗ ",
    done_sym = " ",
    removed_sym = " ",
    moved_sym = "",
  },
  -- max_jobs = 32,
  git = {
    default_url_format = U.get_github_mirror() .. '%s',
    clone_timeout = 120,
  },
}

local packer = nil

local Packer = {}
Packer.__index = Packer
function Packer:load_plugins()
  self.repos = {}

  local get_plugins_list = function()
    local list = {}
    local tmp = vim.split(vim.fn.globpath(mods_dir, '*/plugins.lua'), '\n')
    for _, f in ipairs(tmp) do
      local ff = f
      if U.is_win() then
        ff = string.gsub(ff, '\\', '/')
      end
      list[#list + 1] = string.match(ff, 'lua/(.+).lua$')
    end
    return list
  end

  local plugins_file = get_plugins_list()
  for _, m in ipairs(plugins_file) do
    vim.notify("加载模块 mod=" .. m, vim.log.levels.INFO, { title = 'Packer' })
    require(m)
  end
end

function Packer:load_packer()
  if not packer then
    api.nvim_command('packadd packer.nvim')
    packer = require('packer')
  end
  packer.init(packer_conf)
  packer.reset()
  local use = packer.use
  self:load_plugins()
  use { 'wbthomason/packer.nvim', opt = true }
  use { 'lewis6991/impatient.nvim' }
  for _, repo in ipairs(self.repos) do
    use(repo)
  end
end

function Packer:init_ensure_plugins()
  local state = uv.fs_stat(packer_dir)
  if not state then
    local cmd = '!git clone https://github.com/wbthomason/packer.nvim ' .. packer_dir
    api.nvim_command(cmd)
    uv.fs_mkdir(data_dir .. 'lua', 511, function()
      assert('make compile path dir failed')
    end)
    self:load_packer()
    packer.sync()
  end
end

function Packer:cli_compile()
  self:load_packer()
  packer.compile()
  vim.defer_fn(function()
    vim.cmd('q')
  end, 1000)
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    if key == 'Packer' then
      return Packer
    end
    if not packer then
      Packer:load_packer()
    end
    return packer[key]
  end,
})

function plugins.ensure_plugins()
  Packer:init_ensure_plugins()
end

function plugins.register_plugin(repo)
  if not Packer.repos then
    Packer.repos = {}
  end
  table.insert(Packer.repos, repo)
end

function plugins.auto_compile()
  local file = api.nvim_buf_get_name(0)
  if not file:match(config_path) then
    return
  end
  vim.notify('重新编译中。。。\nfile=' .. file, vim.log.levels.INFO, { title = 'Packer' })
  if file:match('plugins.lua') then
    plugins.clean()
  end
  plugins.compile()
  require('packer_compiled')
end

function plugins.load_compile()
  if vim.fn.filereadable(packer_compiled) == 1 then
    require('packer_compiled')
  end

  -- user cmds
  local cmds = {
    'Compile',
    'Install',
    'Update',
    'Sync',
    'Clean',
    'Status',
  }
  for _, cmd in ipairs(cmds) do
    api.nvim_create_user_command('Packer' .. cmd, function()
      require('plugin.pack')[string.lower(cmd)]()
    end, {})
  end

  -- autocmd
  local PackerHooks = vim.api.nvim_create_augroup('PackerHooks', { clear = true })
  api.nvim_create_autocmd('User', {
    group = PackerHooks,
    pattern = 'PackerCompileDone',
    callback = function()
      vim.notify('编译完成', vim.log.levels.INFO, { title = 'Packer' })
      dofile(vim.env.MYVIMRC)
    end,
  })
  -- config_path 下的任意 lua 文件变更后, 自动重新编译加载
  api.nvim_create_autocmd('BufWritePost', {
    pattern = '*.lua',
    callback = function()
      plugins.auto_compile()
    end,
    desc = 'Auto Compile the neovim config which write in lua',
  })
end

return plugins
