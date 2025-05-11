return {
  { 'tpope/vim-fugitive', cmd = 'Git' },

  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      on_attach = function() require('core.maps').gitsigns() end,
      numhl = true,
    },
  },

  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- "sindrets/diffview.nvim",
    },
    cmd = { 'Neogit', 'NeogitCommit' },
    config = function()
      require('neogit').setup({
        highlight = { italic = false },
      })
      local groups = {
        ['NeogitDiffAdd'] = { link = 'DiffAdd' },
        ['NeogitDiffAddHighlight'] = { link = 'DiffAdd' },
        ['NeogitDiffAddCursor'] = { link = 'Added' },
        ['NeogitDiffDelete'] = { link = 'DiffDelete' },
        ['NeogitDiffDeleteHighlight'] = { link = 'DiffDelete' },
        ['NeogitDiffDeleteCursor'] = { link = 'Removed' },
        ['NeogitDiffDeletions'] = { link = 'Removed' },
        ['NeogitGraphRed'] = { link = 'Removed' },
        ['NeogitGraphBoldRed'] = { link = 'NeogitGraphRed', bold = true, cterm = { bold = true } },
      }
      for k, v in pairs(groups) do
        vim.api.nvim_set_hl(0, k, v)
      end
    end,
  },
}
