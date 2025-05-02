return {
  -- Jetbrains IDEA
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

  -- Helix
  {
    'oneslash/helix-nvim',
    version = '*',
    init = function() vim.cmd('colorscheme helix') end,
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
    -- init = function() vim.cmd('colorscheme dayfox') end,
  },

  {
    'slugbyte/lackluster.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    -- init = function() vim.cmd('colorscheme lackluster') end,
  },

  {
    'pappasam/papercolor-theme-slim',
    lazy = false,
    priority = 1000,
    -- init = function() vim.cmd('colorscheme PaperColorSlim') end,
  },

  {
    'idr4n/github-monochrome.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        comments = { italic = false },
      },
    },
    -- init = function() vim.cmd('colorscheme github-monochrome-solarized') end,
  },
}
