return {
  { 'tpope/vim-fugitive', cmd = 'Git' },

  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- "sindrets/diffview.nvim",
    },
    cmd = { 'Neogit', 'NeogitCommit' },
    opts = {},
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      on_attach = function() require('core.maps').gitsigns() end,
      numhl = true,
    },
  },
}
