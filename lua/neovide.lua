vim.g.neovide_profiler                     = false -- 左上角显示实时帧率

vim.g.neovide_hide_mouse_when_typing       = false -- 输入时隐藏鼠标指针
vim.g.neovide_confirm_quit                 = true  -- 未存盘退出需要确认

vim.g.neovide_scroll_animation_length      = 0.3   -- 滚动动画长度

-- padding
vim.g.neovide_padding_top                  = 0
vim.g.neovide_padding_bottom               = 0
vim.g.neovide_padding_right                = 0
vim.g.neovide_padding_left                 = 0

-- 缩放
vim.g.neovide_scale_factor                 = 1.0
vim.g.neovide_underline_automatic_scaling  = true

-- 透明度
vim.g.neovide_transparency                 = 0.8
vim.g.neovide_floating_blur_amount_x       = 2.0
vim.g.neovide_floating_blur_amount_y       = 2.0

-- 窗口
vim.g.neovide_fullscreen                   = false -- 全屏
vim.g.neovide_remember_window_size         = true  -- 记住上次关闭前的窗口大小

-- 刷新率
vim.g.neovide_no_idle                      = true
vim.g.neovide_refresh_rate                 = 240 -- 刷新率
vim.g.neovide_refresh_rate_idle            = 5   -- 空闲时刷新率

-- 光标
-- vim.g.neovide_cursor_animation_length      = 0.0599 -- 光标动画长度
-- vim.g.neovide_cursor_trail_size            = 0.6999 -- 光标轨迹长度
vim.g.neovide_cursor_antialiasing          = true
-- 光标效果 railgun | torpedo | pixiedust | sonicboom | ripple | wireframe
vim.g.neovide_cursor_vfx_mode              = 'railgun'
vim.g.neovide_cursor_vfx_opacity           = 200.0
vim.g.neovide_cursor_vfx_particle_lifetime = 1.5  -- 粒子生命
vim.g.neovide_cursor_vfx_particle_density  = 30.0 -- 粒子密度
vim.g.neovide_cursor_vfx_particle_speed    = 10.0 -- 粒子速度
vim.g.neovide_cursor_vfx_particle_phase    = 1.5
vim.g.neovide_cursor_vfx_particle_curl     = 1.0

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
map.set('n', '<C-=>', inc_scale)
map.set('n', '<C-->', dec_scale)
map.set('n', '<C-0>', reset_scale)
map.set({ '', 'i' }, '<C-ScrollWheelUp>', inc_scale)
map.set({ '', 'i' }, '<C-ScrollWheelDown>', dec_scale)
