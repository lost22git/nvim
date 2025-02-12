return {
  {
    'Olical/conjure',
    cmd = { 'ConjureConnect' },
    ft = { 'lua', 'fennel' },
    init = function()
      vim.g['conjure#mapping#doc_word'] = { 'gh' }
      vim.g['conjure#extract#tree_sitter#enabled'] = true
      vim.g['conjure#highlight#enabled'] = true
    end,
  },
  {
    'clojure-vim/vim-jack-in',
    cmd = { 'Clj' },
    dependencies = {
      'radenling/vim-dispatch-neovim',
    },
  },
}
