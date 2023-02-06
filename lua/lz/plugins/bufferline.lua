local M = {
  'akinsho/nvim-bufferline.lua',
  event = { 'BufAdd', 'TabEnter' },
}

function M.config()
  local bufferline = require("bufferline")
  local maps = require('core.maps')

  bufferline.setup {
    options = {
      mode = "buffers",
      numbers = 'none',
      close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
      right_mouse_command = '', -- can be a string | function, see "Mouse actions"
      left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
      middle_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
      left_trunc_marker = '',
      right_trunc_marker = '',
      modified_icon = '●',
      offsets = {
        {
          filetype = "drex",
          text = "Drex",
          text_align = "left",
          separator = true,
        },
        {
          filetype = "neo-tree",
          text = "Neo-Tree",
          text_align = "left",
          separator = true,
        }
      },
      always_show_bufferline = false,
      show_buffer_close_icons = false,
      show_close_icon = false,
      color_icons = true,
      ---@diagnostic disable-next-line: assign-type-mismatch
      separator_style = { '', '' }, -- slant | thick | thin | { 'any', 'any' }
      show_tab_indicators = true,
      indicator = {
        -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
        icon = ' ',
        style = 'icon', -- icon | underline | none
      },
      diagnostics = 'nvim_lsp',
      ---@diagnostic disable-next-line: unused-local
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        return '?'
      end,
    },
    -- highlights = require('lz.plugins.vscode').get_bufferline_hl() --vscode
    highlights = require("catppuccin.groups.integrations.bufferline").get() -- catppuccin
  }

  maps.bufferline()

end

return M
