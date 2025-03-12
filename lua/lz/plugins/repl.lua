return {
  {
    'skywind3000/asyncrun.vim',
    lazy = false,
    cmd = { 'AsyncRun', 'AsyncRunVisual' },
    config = function()
      vim.g.asyncrun_bell = 10
      vim.api.nvim_create_user_command('AsyncRunVisual', function(opts)
        -- get selection_text in visual mode
        vim.cmd('normal! gv"xy')
        local selection_text = vim.fn.getreg('x')
        selection_text = vim.fn.trim(selection_text)

        -- write selection_text into tempfile
        local f = vim.fs.dirname(os.tmpname()) .. '/asyncrunvisual.tmp'
        vim.fn.writefile(vim.split(selection_text, '\n'), f)

        -- ensure tempfile accessible
        if vim.fn.has('unix') then os.execute('chmod 777 ' .. f) end

        -- call asyncrun
        vim.cmd('AsyncRun ' .. opts.args .. ' ' .. f)
      end, { nargs = '+', range = true })
    end,
  },

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
          local buffer = vim.api.nvim_get_current_buf()
          if vim.diagnostic.enabled then pcall(vim.diagnostic.enable, false, { bufnr = buffer }) end

          vim.keymap.set(
            { 'n', 'v' },
            '[e',
            [[<Cmd>call search('\v^(;|--) -+$', 'bw')<CR>]],
            { silent = true, buffer = true, desc = 'Conjure goto prev log' }
          )
          vim.keymap.set(
            { 'n', 'v' },
            ']e',
            [[<Cmd>call search('\v^(;|--) -+$', 'w')<CR>]],
            { silent = true, buffer = true, desc = 'Conjure goto next log' }
          )
        end,
      })
    end,
  },
}
