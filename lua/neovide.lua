local g = vim.g

g.neovide_profiler = false -- 左上角显示实时帧率

g.neovide_hide_mouse_when_typing = false -- 输入时隐藏鼠标指针
g.neovide_confirm_quit = true -- 未存盘退出需要确认

g.neovide_scroll_animation_length = 0.3 -- 滚动动画长度

-- 缩放
g.neovide_scale_factor = 1.0
g.neovide_underline_automatic_scaling = true

-- 透明度
g.neovide_transparency = 0.8
-- g.neovide_floating_blur_amount_x = 0.3
-- g.neovide_floating_blur_amount_y = 0.3

-- 窗口
g.neovide_fullscreen = true -- 全屏
g.neovide_remember_window_size = true -- 记住上次关闭前的窗口大小

-- 刷新率
g.neovide_no_idle = true
g.neovide_refresh_rate = 240 -- 刷新率
g.neovide_refresh_rate_idle = 5 -- 空闲时刷新率

-- 光标
-- g.neovide_cursor_animation_length      = 0.0599 -- 光标动画长度
-- g.neovide_cursor_trail_size            = 0.6999 -- 光标轨迹长度
g.neovide_cursor_antialiasing          = true
-- 光标效果 railgun | torpedo | pixiedust | sonicboom | ripple | wireframe
g.neovide_cursor_vfx_mode              = 'railgun'
g.neovide_cursor_vfx_opacity           = 200.0
g.neovide_cursor_vfx_particle_lifetime = 1.5 -- 粒子生命
g.neovide_cursor_vfx_particle_density  = 30.0 -- 粒子密度
g.neovide_cursor_vfx_particle_speed    = 10.0 -- 粒子速度
g.neovide_cursor_vfx_particle_phase    = 1.5
g.neovide_cursor_vfx_particle_curl     = 1.0

-- 开启/关闭 全屏
local function toggle_fullscreen()
  vim.g.neovide_fullscreen = not (vim.g.neovide_fullscreen or false)
end

-- 增加/减小 透明度
local function inc_transparency()
  local v = vim.g.neovide_transparency + 0.1
  v = v > 1.0 and 1.0 or v
  print("Increase neovide_transparency to " .. v)
  vim.g.neovide_transparency = v
end

local function dec_transparency()
  local v = vim.g.neovide_transparency - 0.1
  v = v < 0.1 and 0 or v
  print("Decrease neovide_transparency to " .. v)
  vim.g.neovide_transparency = v
end

-- 增加/减小/重置 缩放比例
local function inc_scale()
  local v = vim.g.neovide_scale_factor + 0.1
  print("Increase neovide_scale_factor to " .. v)
  vim.g.neovide_scale_factor = v
end

local function dec_scale()
  local v = vim.g.neovide_scale_factor - 0.1
  v = v < 0.1 and 0.1 or v
  print("Decrease neovide_scale_factor to " .. v)
  vim.g.neovide_scale_factor = v
end

local function reset_scale()
  vim.g.neovide_scale_factor = 1.0
end

-- keymaps
local map = vim.keymap
map.set({ '', 'i' }, '<M-Enter>', toggle_fullscreen)
map.set({ 'n' }, '+', inc_transparency)
map.set({ 'n' }, '_', dec_transparency)
map.set('n', 'zi', inc_scale)
map.set('n', 'zo', dec_scale)
map.set('n', 'zz', reset_scale)
map.set({ '', 'i' }, '<M-9>', '<cmd>messages<CR>')
