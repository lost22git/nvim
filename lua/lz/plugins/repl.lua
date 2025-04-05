return {
  {
    'Olical/conjure',
    cmd = { 'ConjureConnect' },
    ft = { 'lua', 'fennel', 'clojure' },
    init = function()
      vim.g['conjure#extract#tree_sitter#enabled'] = true
      vim.g['conjure#highlight#enabled'] = true
      vim.g['conjure#mapping#doc_word'] = { '<LocalLeader>k' }
      vim.g['conjure#mapping#log_toggle'] = { '<LocalLeader>lk' }
      vim.g['conjure#mapping#eval_previous'] = { '<LocalLeader>el' }
      vim.g['conjure#mapping#eval_replace_form'] = { '<LocalLeader>es' }

      vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
        pattern = { 'conjure-log-*' },
        callback = function()
          -- disable `vim.diagnostic`
          local buffer = vim.api.nvim_get_current_buf()
          if vim.diagnostic.is_enabled({ bufnr = buffer }) then
            pcall(vim.diagnostic.enable, false, { bufnr = buffer })
          end

          local p = [[\v^(;|--) -+$]]
          local prev = string.format([[<Cmd>call search('%s', 'bw')<CR>]], p)
          local next = string.format([[<Cmd>call search('%s', 'w')<CR>]], p)
          vim.keymap.set({ 'n', 'v' }, '[e', prev, { silent = true, buffer = true, desc = '[conjure] Goto prev log' })
          vim.keymap.set({ 'n', 'v' }, ']e', next, { silent = true, buffer = true, desc = '[conjure] Goto next log' })
        end,
      })
    end,
  },
}
