local M = {
  "mcchrish/zenbones.nvim",
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'zenbones',

  dependencies = {
    "rktjmp/lush.nvim"
  },
}

function M.init()
  local themes = {
    'zenwritten',
    'neobones',
    'vimbones',
    'rosebones',
    'forestbones',
    'nordbones',
    'tokyobones',
    'seoulbones',
    'duckbones',
    'zenburned',
    'kanagawabones',
  }

  for _, name in pairs(themes) do
    vim.g[name] = {
      darkness = 'warm', -- stark or warm
      lightness = 'dim', -- bright or dim

      transparent_background = vim.g.transparent,
      italic_comments = false,
      darken_noncurrent_window = true,
    }
  end

  -- disable italic for `Constant` and `Number`
  vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
    pattern = {'zen*', '*bones'},
    callback = function(params)
      local base = require(params.match)
      vim.api.nvim_set_hl(0, "Constant", { fg = base.Constant.fg.hex })
      vim.api.nvim_set_hl(0, "Number", { fg = base.Number.fg.hex })
    end
  })

  vim.cmd.colorscheme(themes[(vim.fn.rand() % vim.fn.len(themes)) + 1])
end

return M
