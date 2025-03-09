return {

  { 'MunifTanjim/nui.nvim' },

  -- {
  --   'mikesmithgh/borderline.nvim',
  --   lazy = false,
  --   config = function()
  --     require('borderline').setup({})
  --     require('borderline.api').borderline('rounded')
  --   end,
  -- },

  {
    'lost22git/true-zen.nvim',
    branch = 'fix-by-lost',
    cmd = { 'TZNarrow', 'TZFocus', 'TZMinimalist', 'TZAtaraxis' },
    opts = {},
  },

  {
    'NvChad/nvim-colorizer.lua',
    cmd = { 'ColorizerAttachToBuffer' },
    opts = {
      user_default_options = {
        tailwind = true,
        mode = 'virtualtext',
        virtualtext = '■',
      },
    },
  },

  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPost', 'BufNewFile' },
    keys = {
      { '[t', function() require('todo-comments').jump_prev() end, mode = { 'n', 'v' }, desc = 'Goto prev TODO' },
      { ']t', function() require('todo-comments').jump_next() end, mode = { 'n', 'v' }, desc = 'Goto next TODO' },
    },
    opts = {},
  },

  {
    'nyngwang/NeoZoom.lua',
    keys = { { '<Leader>z', '<Cmd>NeoZoomToggle<CR>', mode = { 'n', 'v' }, desc = 'NeoZoom' } },
    opts = {
      popup = { enabled = true },
      exclude_buftypes = { 'terminal' },
      winopts = {
        offset = { width = 150, height = 0.85 },
        border = 'rounded',
      },
      presets = {
        {
          filetypes = { 'dapui_.*', 'dap-repl' },
          winopts = {
            offset = { top = 0.02, left = 0.26, width = 0.74, height = 0.25 },
          },
        },
        {
          filetypes = { 'markdown' },
          callbacks = { function() vim.wo.wrap = true end },
        },
      },
    },
    config = function(_, opts)
      require('neo-zoom').setup(opts)

      vim.api.nvim_create_autocmd({ 'WinEnter' }, {
        callback = function()
          local zoom_book = require('neo-zoom').zoom_book

          if require('neo-zoom').is_neo_zoom_float() then
            for z, _ in pairs(zoom_book) do
              vim.wo[z].winbl = 0
            end
          else
            for z, _ in pairs(zoom_book) do
              vim.wo[z].winbl = 20
            end
          end
        end,
      })
    end,
  },

  {
    'zaldih/themery.nvim',
    cmd = { 'Themery' },
    opts = {
      themes = vim.fn.getcompletion('', 'color'),
      livePreview = true,
    },
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
        desc = 'WindowPicker',
      },
    },
    opts = {},
  },

  {
    'EL-MASTOR/bufferlist.nvim',
    keys = { { '<Leader>b', ':BufferList<CR>', desc = 'BufferList' } },
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
            { desc = 'BufferList: open cursorhold buffer' },
          },
          {
            'r', -- refresh the bufferlist window
            function(opts) refresh_bufferlist(opts.open_bufferlist) end,
            { desc = 'BufferList: refresh bufferlist' },
          },
          {
            'dd',
            function(opts)
              local curpos = vim.fn.line('.')
              close_buffer(opts.buffers, curpos, false)
              refresh_bufferlist(opts.open_bufferlist)
            end,
            { desc = 'BufferList: delete cursorhold buffer' },
          },
          {
            'DD',
            function(opts)
              local curpos = vim.fn.line('.')
              close_buffer(opts.buffers, curpos, true)
              refresh_bufferlist(opts.open_bufferlist)
            end,
            { desc = 'BufferList: force to delete cursorhold buffer' },
          },
          {
            'do',
            function(opts)
              local curpos = vim.fn.line('.')
              close_others(opts.buffers, curpos, false)
              refresh_bufferlist(opts.open_bufferlist)
            end,
            { desc = 'BufferList: delete other buffer' },
          },
          {
            'vs',
            function(opts)
              local curpos = vim.fn.line('.')
              local bufname = vim.fn.bufname(opts.buffers[curpos])
              vim.cmd('bwipeout | vs ' .. bufname)
            end,
            { desc = 'BufferList: vertically split cursorhold buffer' },
          },
          {
            'sp',
            function(opts)
              local curpos = vim.fn.line('.')
              local bufname = vim.fn.bufname(opts.buffers[curpos])
              vim.cmd('bwipeout | sp ' .. bufname)
            end,
            { desc = 'BufferList: horizontally split cursorhold buffer' },
          },
        },
      }
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    keys = { { '<Leader>i', '<Cmd>IBLToggle<CR>', mode = { 'n', 'v' }, desc = 'IBL' } },
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },

  {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    keys = {
      { '<Leader>q', function() require('quicker').toggle() end, desc = 'Toggle quickfix' },
      { '<Leader>l', function() require('quicker').toggle({ loclist = true }) end, desc = 'Toggle loclist' },
    },
    opts = {
      keys = {
        {
          '>',
          function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end,
          desc = 'Expand quickfix context',
        },
        {
          '<',
          function() require('quicker').collapse() end,
          desc = 'Collapse quickfix context',
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
        desc = 'FTerm',
      },
    },
    opts = {
      ft = 'FTerm',
      cmd = vim.g.term_shell or vim.o.shell,
      border = 'rounded',
      auto_close = true,
      hl = 'Normal',
      blend = 0,
      dimensions = { height = 0.8, width = 0.8, x = 0.5, y = 0.5 },
      on_exit = nil,
      on_stdout = nil,
      on_stderr = nil,
    },
  },
}
