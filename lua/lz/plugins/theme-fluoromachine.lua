local M = {
  'maxmx03/fluoromachine.nvim',
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'fluoromachine',
}

function M.config()
  require('fluoromachine').setup {
    glow = true,
    brightness = 0.4,
    theme = 'fluoromachine',
    transparent = vim.g.transparent and 'full' or false,

    overrides = {
      ['@type'] = { italic = false, bold = false },
      ['@function'] = { italic = false, bold = false },
      ['@comment'] = { italic = false },
      ['@keyword'] = { italic = false },
      ['@constant'] = { italic = false, bold = false },
      ['@variable'] = { italic = false },
      ['@field'] = { italic = false },
      ['@parameter'] = { italic = false },
    }
  }
  vim.cmd.colorscheme 'fluoromachine'
end

return M
