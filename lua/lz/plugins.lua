return {
  --------
  -- UI --
  --------

  { 'MunifTanjim/nui.nvim' },

  -----------
  -- Theme --
  -----------

  {
    'nickkadutskyi/jb.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('jb').setup({ transparent = false })
      vim.cmd('colorscheme jb')
    end,
  },

  -------------------
  -- cursor effect --
  -------------------

  -- {
  --   'sphamba/smear-cursor.nvim',
  --   event = 'VeryLazy',
  --   config = function()
  --     require('smear_cursor').setup({
  --       -- cursor_color = '#6e6a86',
  --     })
  --   end,
  -- },

  -------------------
  -- mode colorize --
  -------------------

  -- {
  --   'mvllow/modes.nvim',
  --   tag = 'v0.2.0',
  --   lazy = false,
  --   config = function() require('modes').setup() end,
  -- },

  ----------------------------
  -- border global settings --
  ----------------------------

  {
    'mikesmithgh/borderline.nvim',
    event = 'VeryLazy',
    config = function()
      require('borderline').setup({})
      require('borderline.api').borderline('rounded')
    end,
  },

  --------------
  -- True Zen --
  --------------

  {
    -- "Pocco81/true-zen.nvim",
    'ilan-schemoul/true-zen.nvim',
    enabled = not vim.g.vscode,
    branch = 'fix-restore-value',
    cmd = { 'TZNarrow', 'TZFocus', 'TZMinimalist', 'TZAtaraxis' },
    config = function() require('true-zen').setup({}) end,
  },

  ------------------
  -- 颜色代码高亮 --
  ------------------

  {
    'NvChad/nvim-colorizer.lua',
    cmd = { 'ColorizerAttachToBuffer' },
    config = function()
      require('colorizer').setup({
        user_default_options = {
          tailwind = true,
          mode = 'virtualtext',
          virtualtext = '■',
        },
      })
    end,
  },

  ----------
  -- TODO --
  ----------

  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('todo-comments').setup({})
      require('core.maps').todo()
    end,
  },

  --------------
  -- 保护颈椎 --
  --------------

  {
    'nyngwang/NeoZoom.lua',
    enabled = not vim.g.vscode,
    keys = { ';' },
    config = function()
      require('neo-zoom').setup({
        popup = { enabled = true },
        exclude_buftypes = { 'terminal' },
        winopts = {
          offset = {
            -- top = 0,
            -- left = 0.17,
            width = 150,
            height = 0.85,
          },
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
            callbacks = {
              function() vim.wo.wrap = true end,
            },
          },
        },
      })

      vim.keymap.set('n', ';', function() vim.cmd('NeoZoomToggle') end, { silent = true, nowait = true })

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

  ------------
  -- 滚动条 --
  ------------
  {
    'lewis6991/satellite.nvim',
    enabled = not vim.g.vscode,
    event = { 'BufReadPost', 'BufNewFile' },
    ---@diagnostic disable-next-line: missing-fields
    config = function() require('satellite').setup({}) end,
  },

  --------------------------------
  -- theme preview and switcher --
  --------------------------------
  {
    'zaldih/themery.nvim',
    cmd = { 'Themery' },
    config = function()
      require('themery').setup({
        themes = vim.fn.getcompletion('', 'color'),
        livePreview = true,
      })
    end,
  },

  --------------------
  -- windows picker --
  --------------------

  {
    's1n7ax/nvim-window-picker',
    enabled = not vim.g.vscode,
    keys = { '<Leader>w' },
    config = function()
      require('window-picker').setup({
        autoselect_one = true,
        include_current_win = false,
        selection_chars = 'FJDKSLA;CMRUEIWOQP',
        use_winbar = 'never', -- "always" | "never" | "smart"
        show_prompt = true,
        filter_func = nil,
        filter_rules = {
          bo = {
            filetype = { 'NvimTree', 'neo-tree', 'notify', 'drex' },
            buftype = { 'terminal' },
          },
          wo = {},
          file_path_contains = {},
          file_name_contains = {},
        },
        fg_color = '#ededed',
        current_win_hl_color = '#e35e4f',
        other_win_hl_color = '#0a7aca',
        selection_display = function(char) return char end,
      })
      require('core.maps').window_picker()
    end,
  },

  ----------------
  -- bufferlist --
  ----------------

  {
    'EL-MASTOR/bufferlist.nvim',
    keys = { { '<Leader>b', ':BufferList<CR>', desc = 'Open bufferlist' } },
    cmd = 'BufferList',
    config = function()
      local function close_buffer(listed_bufs, index, force)
        local bn = listed_bufs[index]
        if vim.bo[bn].buftype == 'terminal' and not force then return nil end
        local command = (force and 'bd! ' or 'bd ') .. bn
        vim.cmd(command)
        if vim.fn.bufexists(bn) == 1 and vim.bo[bn].buflisted then
          vim.api.nvim_buf_call(bn, function() vim.cmd(command) end)
        end
      end

      require('bufferlist').setup({
        keymap = {
          close_buf_prefix = 'd',
          force_close_buf_prefix = 'D',
          multi_close_buf = 'md',
          close_all_saved = 'ad',
          save_buf = 'w',
          multi_save_buf = 'mw',
          save_all_unsaved = 'aw',
          toggle_path = 'p',
          -- close_bufferlist = '<C-c>',
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
            function(opts)
              vim.cmd('bwipeout')
              opts.open_bufferlist()
            end,
            { desc = 'BufferList: refresh bufferlist' },
          },
          {
            'dd',
            function(opts)
              local curpos = vim.fn.line('.')
              close_buffer(opts.buffers, curpos, false)
              vim.cmd('bwipeout')
              opts.open_bufferlist()
            end,
            { desc = 'BufferList: delete cursorhold buffer' },
          },
          {
            'DD',
            function(opts)
              local curpos = vim.fn.line('.')
              close_buffer(opts.buffers, curpos, true)
              vim.cmd('bwipeout')
              opts.open_bufferlist()
            end,
            { desc = 'BufferList: force to delete cursorhold buffer' },
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
      })
    end,
  },
}
