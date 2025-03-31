return {
  {
    'nickkadutskyi/jb.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      disable_hl_args = { bold = false, italic = true },
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
    -- init = function() vim.cmd('colorscheme cyberdream') end,
  },

  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      groups = {
        all = {
          MiniCursorWord = { link = 'Underlined' },
          MiniCursorWordCurrent = { link = 'Underlined' },
        },
      },
    },
    init = function() vim.cmd('colorscheme dayfox') end,
  },
}
