local M = {
  'romgrk/barbar.nvim',
  event = { 'BufAdd', 'TabEnter' },
  init = function() vim.g.barbar_auto_setup = false end,
  version = '^1.0.0', -- optional: only update when a new 1.x version is released
}

function M.config()
  require 'barbar'.setup {
    -- Enable/disable animations
    animation = false,

    -- Enable/disable auto-hiding the tab bar when there is a single buffer
    auto_hide = false,

    -- Enable/disable current/total tabpages indicator (top right corner)
    tabpages = true,

    -- Enables/disable clickable tabs
    --  - left-click: go to buffer
    --  - middle-click: delete buffer
    clickable = true,
  }
  require "core.maps".barbar()
end

return M
