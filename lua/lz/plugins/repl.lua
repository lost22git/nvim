vim.api.nvim_create_autocmd('FileType', {
  desc = 'add `Clj` command to start Clojure nREPL server',
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

vim.api.nvim_create_autocmd('FileType', {
  desc = 'add `JanetNetrepl` command to start janet-netrepl server',
  pattern = { 'janet' },
  callback = function()
    vim.api.nvim_buf_create_user_command(0, 'JanetNetrepl', function()
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
      vim.g['conjure#mapping#eval_visual'] = { '<LocalLeader>ee' }
      vim.g['conjure#mapping#eval_replace_form'] = { '<LocalLeader>es' }
      vim.g['conjure#mapping#eval_previous'] = { '<LocalLeader>E' }

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

  {
    'pappasam/nvim-repl',
    cmd = { 'Repl' },
    opts = {
      filetype_commands = {
        crystal = { cmd = 'crystal i' },
        java = { cmd = 'jshell' },
        nim = { cmd = 'inim' },
        nims = { cmd = 'inim' },
        raku = { cmd = 'rlwrap raku' },
        swift = { cmd = 'swift repl' },
      },
    },
    config = function(_, opts)
      require('repl').setup(opts)

      local ftypes = vim.tbl_keys(opts.filetype_commands)

      local create_keymaps = function()
        vim.keymap.set({ 'n' }, '<Leader>ee', '<Plug>(ReplSendLine)', { buffer = true, desc = '[repl] Send Line' })
        vim.keymap.set(
          { 'v' },
          '<Leader>ee',
          '<Plug>(ReplSendVisual)',
          { buffer = true, desc = '[repl] Send Visual Selection' }
        )
        vim.keymap.set({ 'n' }, '<Leader>er', '<Plug>(ReplSendCell)', { buffer = true, desc = '[repl] Send Cell' })
      end

      -- autocmd
      local callback = function() create_keymaps() end
      vim.api.nvim_create_autocmd('FileType', { pattern = ftypes, callback = callback })

      -- also run callback if current buffer matches conditions
      if vim.tbl_contains(ftypes, vim.bo.filetype) then callback() end
    end,
  },
}
