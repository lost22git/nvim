return {
  {
    'nickkadutskyi/jb.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
    },
    -- init = function() vim.cmd('colorscheme jb') end,
  },

  {
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      variant = 'light',
      transparent = false,
      cache = true,
    },
    init = function() vim.cmd('colorscheme cyberdream') end,
  },
}
