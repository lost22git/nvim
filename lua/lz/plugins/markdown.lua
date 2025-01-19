return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = not vim.g.vscode,
    ft = 'markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
    opts = {},
  },

  {
    'Kicamon/markdown-table-mode.nvim',
    ft = 'markdown',
    config = function() require('markdown-table-mode').setup() end,
  },
}
