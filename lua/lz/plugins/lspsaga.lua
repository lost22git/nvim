local M = {
  'glepnir/lspsaga.nvim',
  enabled = not vim.g.vscode,
  cmd = { 'Lspsaga' },
}

function M.config()
  local saga = require('lspsaga')

  saga.setup({
    scroll_preview = {
      scroll_down = '<C-d>',
      scroll_up = '<C-u>',
    },
    symbol_in_winbar = {
      enable = true,
      separator = ' ',
      ignore_patterns = {},
      hide_keyword = true,
      show_file = true,
      folder_level = 2,
      respect_root = false,
      color_mode = true,
    },
    beacon = {
      enable = true,
      frequency = 7,
    },
    ui = {
      title = true,
      border = 'rounded',
      winblend = 0,
      expand = '',
      collapse = '',
      code_action = '💡',
      incoming = ' ',
      outgoing = ' ',
      hover = ' ',
      kind = {},
    },
  })

  require('core.maps').lspsaga()
end

return M
