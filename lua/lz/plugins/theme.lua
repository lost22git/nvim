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
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      compile = true,
      commentStyle = { italic = false },
      functionStyle = { italic = false },
      keywordStyle = { italic = false },
      statementStyle = { bold = true, italic = false },
      typeStyle = { italic = false },
    },
    init = function() vim.cmd('colorscheme kanagawa') end,
  },
}
