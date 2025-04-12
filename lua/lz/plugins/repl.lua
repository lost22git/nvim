-- autocmd: Start Clojure nREPL server
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'clojure' },
  callback = function()
    vim.api.nvim_buf_create_user_command(0, 'Clj', function(opts)
      local clj_opts = string.match(opts.args, '%-M:') and opts.args or (opts.args .. ' ' .. '-M')

      local deps =
        [['{:deps {nrepl/nrepl {:mvn/version "1.3.0"} refactor-nrepl/refactor-nrepl {:mvn/version "3.10.0"} cider/cider-nrepl {:mvn/version "0.52.0"} }}']]

      local cider_opts =
        [["(require 'nrepl.cmdline) (nrepl.cmdline/-main \"--interactive\" \"--middleware\" \"[ refactor-nrepl.middleware/wrap-refactor cider.nrepl/cider-middleware]\")"]]

      local command = string.format('clj -Sdeps %s %s -e %s', deps, clj_opts, cider_opts)
      local call_asyncrun = 'AsyncRun -mode=term -pos=tab -focus=0 ' .. command
      vim.print(call_asyncrun)
      vim.cmd(call_asyncrun)
    end, { nargs = '*' })
  end,
})

-- autocmd: Start Janet netrepl server
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'janet' },
  callback = function()
    vim.api.nvim_buf_create_user_command(0, 'JanetNetrepl', function(opts)
      local command = 'janet-netrepl'
      local call_asyncrun = 'AsyncRun -mode=term -pos=tab -focus=0 ' .. command
      vim.print(call_asyncrun)
      vim.cmd(call_asyncrun)
    end, { nargs = '*' })
  end,
})

return {
  {
    'Olical/conjure',
    cmd = { 'ConjureConnect' },
    ft = { 'lua', 'fennel', 'clojure', 'janet' },
    init = function()
      vim.g['conjure#highlight#enabled'] = true
      vim.g['conjure#extract#tree_sitter#enabled'] = true
      vim.g['conjure#log#jump_to_latest#enabled'] = true
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

          local p = [[\v^(;|--|#) -+$]]
          local prev = string.format([[<Cmd>call search('%s', 'bw')<CR>]], p)
          local next = string.format([[<Cmd>call search('%s', 'w')<CR>]], p)
          vim.keymap.set({ 'n', 'v' }, '[e', prev, { silent = true, buffer = true, desc = '[conjure] Goto prev log' })
          vim.keymap.set({ 'n', 'v' }, ']e', next, { silent = true, buffer = true, desc = '[conjure] Goto next log' })
        end,
      })
    end,
  },
}
