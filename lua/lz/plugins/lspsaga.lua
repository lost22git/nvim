local M = {
  "glepnir/lspsaga.nvim",
  cmd = { "Lspsaga" },
}

function M.config()
  local saga = require('lspsaga')

  saga.setup {
    scroll_preview = {
      scroll_down = '<C-d>',
      scroll_up = '<C-u>',
    },
    symbol_in_winbar = {
      enable = true,
      separator = ' ',
      hide_keyword = true,
      show_file = true,
      folder_level = 2,
      respect_root = false,
    },
    ui = {
      -- currently only round theme
      theme = 'round',
      -- border type can be single,double,rounded,solid,shadow.
      border = 'rounded',
      winblend = 0,
      expand = '',
      collapse = '',
      preview = ' ',
      code_action = '💡',
      diagnostic = '🐞',
      incoming = ' ',
      outgoing = ' ',

      colors = require("catppuccin.groups.integrations.lsp_saga").custom_colors(),
      kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
    },
  }
  require('core.maps').lspsaga()
end

return M
