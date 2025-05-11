return {
  { 'windwp/nvim-autopairs', event = { 'InsertEnter' }, opts = {} },

  { 'HiPhish/rainbow-delimiters.nvim', submodules = false, event = { 'BufReadPost', 'BufNewFile' } },

  { 'utilyre/sentiment.nvim', event = { 'BufReadPost', 'BufNewFile' }, opts = {} },
}
