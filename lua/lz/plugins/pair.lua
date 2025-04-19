return {
  { 'windwp/nvim-autopairs', event = { 'InsertEnter' }, opts = {} },

  { 'HiPhish/rainbow-delimiters.nvim', submodules = false, event = { 'BufReadPost', 'BufNewFile' } },

  {
    'utilyre/sentiment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },
}
