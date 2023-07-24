----------------------------------------
--             滚动条
----------------------------------------

local M = {
  'lewis6991/satellite.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  enabled = function()
    local current = vim.version()
    local min = vim.version.parse('0.10')
    return vim.version.cmp(current, min) >= 0
  end,
}

function M.config()
  require('satellite').setup {
    current_only = false,
    winblend = 50,
    zindex = 40,
    excluded_filetypes = {},
    width = 10,
    handlers = {
      search = {
        enable = true,
      },
      diagnostic = {
        enable = true,
      },
      gitsigns = {
        enable = true,
        signs = {
          -- can only be a single character (multibyte is okay)
          add = "│",
          change = "│",
          delete = "-",
        },
      },
      marks = {
        enable = true,
        show_builtins = false, -- shows the builtin marks like [ ] < >
      },
    },
  }
end

return M
