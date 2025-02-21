return {
  {
    'Olical/conjure',
    cmd = { 'ConjureConnect' },
    ft = { 'lua', 'fennel', 'clojure' },
    init = function()
      vim.g['conjure#extract#tree_sitter#enabled'] = true
      vim.g['conjure#highlight#enabled'] = true
      vim.g['conjure#mapping#doc_word'] = { 'gh' }
      vim.g['conjure#mapping#log_toggle'] = { '<LocalLeader>lk' }
      vim.g['conjure#mapping#eval_previous'] = { '<LocalLeader>el' }
      vim.g['conjure#mapping#eval_replace_form'] = { '<LocalLeader>es' }

      vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
        pattern = { 'conjure-log-*' },
        callback = function()
          vim.keymap.set(
            { 'n', 'v' },
            '[e',
            [[<Cmd>call search('^; -\+$', 'bw')<CR>]],
            { silent = true, buffer = true, desc = 'Goto prev log' }
          )
          vim.keymap.set(
            { 'n', 'v' },
            ']e',
            [[<Cmd>call search('^; -\+$', 'w')<CR>]],
            { silent = true, buffer = true, desc = 'Goto next log' }
          )
        end,
      })
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
