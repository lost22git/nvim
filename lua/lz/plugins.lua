return {
  {
    'skywind3000/asyncrun.vim',
    lazy = false,
    cmd = { 'AsyncRun', 'AsyncRunVisual' },
    config = function()
      vim.g.asyncrun_bell = 10
      -- AsyncRunVisual
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
    'TheBlob42/houdini.nvim',
    event = { 'InsertEnter', 'CmdLineEnter', 'TermEnter' },
    opts = {
      timeout = 250,
      escape_sequences = {
        ['v'] = false,
        ['V'] = false,
        ['c'] = '<BS><BS><Esc>',
      },
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    keys = { { '<Leader>i', '<Cmd>IBLToggle<CR>', mode = { 'n', 'v' }, desc = '[IBL] Toggle' } },
    opts = {
      indent = { char = '▏' },
    },
  },

  {
    'ukyouz/syntax-highlighted-cursor.nvim',
    lazy = false,
    config = function()
      require('syntax-highlighted-cursor').setup({})
      vim.opt.guicursor:append('t-c:ver30-Cursor')
    end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    cmd = { 'ColorizerAttachToBuffer' },
    opts = {
      user_default_options = {
        tailwind = true,
        mode = 'virtualtext',
        virtualtext_inline = 'before',
      },
    },
  },

  {
    'nvim-focus/focus.nvim',
    cmd = { 'FocusEnable' },
    opts = { ui = { cursorline = false, signcolumn = false } },
  },

  {
    'lost22git/true-zen.nvim',
    branch = 'fix-by-lost',
    keys = {
      { '<Leader>za', '<Cmd>TZAtaraxis<CR>', desc = '[true-zen] TZAtaraxis' },
      { '<Leader>zf', '<Cmd>TZFocus<CR>', desc = '[true-zen] TZFocus' },
      { '<Leader>zm', '<Cmd>TZMinimalist<CR>', desc = '[true-zen] TZMinimalist' },
      { '<Leader>zn', '<Cmd>TZNarrow<CR>', desc = '[true-zen] TZNarrow' },
    },
    opts = {},
  },

  {
    's1n7ax/nvim-window-picker',
    keys = {
      {
        '<Leader>w',
        function()
          local win_id = require('window-picker').pick_window() or vim.api.nvim_get_current_win()
          vim.api.nvim_set_current_win(win_id)
        end,
        mode = { 'n', 'v' },
        desc = '[window-picker] Pick window',
      },
    },
    opts = {
      hint = 'floating-big-letter',
      filter_rules = { bo = { buftype = {} } },
    },
  },

  {
    'EL-MASTOR/bufferlist.nvim',
    keys = { { '<Leader>b', ':BufferList<CR>', desc = '[bufferlist] Open' } },
    cmd = 'BufferList',
    opts = function()
      local function close_buffer(listed_bufs, index, force)
        local bn = listed_bufs[index]
        if vim.bo[bn].buftype == 'terminal' and not force then return nil end
        local command = (force and 'bd! ' or 'bd ') .. bn
        vim.cmd(command)
        if vim.fn.bufexists(bn) == 1 and vim.bo[bn].buflisted then
          vim.api.nvim_buf_call(bn, function() vim.cmd(command) end)
        end
      end
      local function close_others(listed_bufs, index, force)
        for i, _ in pairs(listed_bufs) do
          if i ~= index then close_buffer(listed_bufs, i, force) end
        end
      end
      local function refresh_bufferlist(open_bufferlist)
        vim.cmd('bwipeout')
        open_bufferlist()
      end

      return {
        keymap = {
          close_buf_prefix = 'd',
          force_close_buf_prefix = 'D',
          multi_close_buf = 'md',
          close_all_saved = 'ad',
          save_buf = 'w',
          multi_save_buf = 'mw',
          save_all_unsaved = 'aw',
          toggle_path = 'p',
          close_bufferlist = 'q',
        },
        win_keymaps = {
          {
            'o',
            function(opts)
              local curpos = vim.fn.line('.')
              vim.cmd('bwipeout | buffer ' .. opts.buffers[curpos])
            end,
            { desc = '[bufferlist] Open cursorhold' },
          },
          {
            'r', -- refresh the bufferlist window
            function(opts) refresh_bufferlist(opts.open_bufferlist) end,
            { desc = '[bufferlist] Refresh' },
          },
          {
            'dd',
            function(opts)
              local curpos = vim.fn.line('.')
              close_buffer(opts.buffers, curpos, false)
              refresh_bufferlist(opts.open_bufferlist)
            end,
            { desc = '[bufferlist] Delete cursorhold' },
          },
          {
            'DD',
            function(opts)
              local curpos = vim.fn.line('.')
              close_buffer(opts.buffers, curpos, true)
              refresh_bufferlist(opts.open_bufferlist)
            end,
            { desc = '[bufferlist] Force to delete cursorhold' },
          },
          {
            'do',
            function(opts)
              local curpos = vim.fn.line('.')
              close_others(opts.buffers, curpos, false)
              refresh_bufferlist(opts.open_bufferlist)
            end,
            { desc = '[bufferlist] Delete others' },
          },
          {
            '<C-v>',
            function(opts)
              local curpos = vim.fn.line('.')
              local bufname = vim.fn.bufname(opts.buffers[curpos])
              vim.cmd('bwipeout | vs ' .. bufname)
            end,
            { desc = '[bufferlist] Vertically split cursorhold' },
          },
          {
            '<C-s>',
            function(opts)
              local curpos = vim.fn.line('.')
              local bufname = vim.fn.bufname(opts.buffers[curpos])
              vim.cmd('bwipeout | sp ' .. bufname)
            end,
            { desc = '[bufferlist] Horizontally split cursorhold' },
          },
        },
      }
    end,
  },

  {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    keys = {
      { '<Leader>q', function() require('quicker').toggle() end, desc = '[quicker] Toggle qflist' },
      { '<Leader>l', function() require('quicker').toggle({ loclist = true }) end, desc = '[quicker] Toggle loclist' },
    },
    opts = {
      keys = {
        {
          '>',
          function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end,
          desc = '[quicker] Expand context',
        },
        {
          '<',
          function() require('quicker').collapse() end,
          desc = '[quicker] Collapse context',
        },
      },
    },
  },

  {
    'numToStr/FTerm.nvim',
    keys = {
      {
        '<M-3>',
        '<C-\\><C-n><Cmd>lua require("FTerm").toggle()<CR>',
        mode = { 'n', 'v', 'i', 't' },
        noremap = true,
        desc = '[FTerm] Toggle',
      },
    },
    opts = {
      ft = 'FTerm',
      cmd = vim.g.LC.shell or vim.o.shell,
      border = vim.opt.winborder:get(),
    },
  },
}
