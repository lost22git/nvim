return {
  {
    'echasnovski/mini.icons',
    lazy = false,
    config = function()
      require('mini.icons').setup({})
      MiniIcons.mock_nvim_web_devicons()
    end,
  },

  {
    'echasnovski/mini.statusline',
    lazy = false,
    opts = {
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local diff = MiniStatusline.section_diff({ trunc_width = 75 })
          local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local location = MiniStatusline.section_location({ trunc_width = 75 })
          local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

          -- show buffer count
          local buffers = '󱂬 ' .. require('core.utils').get_buffer_count()

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { buffers, fileinfo } },
            { hl = mode_hl, strings = { search, location } },
          })
        end,
        inactive = nil,
      },

      use_icons = true,
      set_vim_settings = true,
    },
  },

  -- {
  --   'echasnovski/mini.notify',
  --   lazy = false,
  --   keys = {
  --     { '<Leader>n', function() MiniNotify.show_history() end, mode = { 'n', 'v' }, desc = 'MiniNotify history' },
  --   },
  --   opts = {},
  -- },

  {
    'echasnovski/mini.files',
    keys = {
      ---@diagnostic disable-next-line: undefined-global
      { '<M-1>', function() MiniFiles.open() end, desc = 'MiniFiles open' },
      ---@diagnostic disable-next-line: undefined-global
      {
        '<M-2>',
        function() MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end,
        desc = 'MiniFiles open current directory',
      },
    },
    opts = {
      -- Customization of shown content
      content = {
        -- Predicate for which file system entries to show
        filter = nil,
        -- What prefix to show to the left of file system entry
        prefix = nil,
        -- In which order to show file system entries
        sort = nil,
      },
      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        close = 'q',
        go_in = 'l',
        go_in_plus = 'L',
        go_out = 'h',
        go_out_plus = 'H',
        reset = '<BS>',
        show_help = 'g?',
        synchronize = '=',
        trim_left = '<',
        trim_right = '>',
      },
      -- General options
      options = {
        -- Whether to delete permanently or move into module-specific trash
        permanent_delete = true,
        -- Whether to use for editing directories
        use_as_default_explorer = true,
      },
      -- Customization of explorer windows
      windows = {
        -- Maximum number of windows to show side by side
        max_number = math.huge,
        -- Whether to show preview of file/directory under cursor
        preview = true,
        -- Width of focused window
        width_focus = 50,
        -- Width of non-focused window
        width_nofocus = 15,
        -- Width of preview window
        width_preview = 25,
      },
    },
    config = function(_, opts)
      require('mini.files').setup(opts)

      local yank_full_path = function()
        ---@diagnostic disable-next-line: undefined-global
        local path = MiniFiles.get_fs_entry().path
        vim.fn.setreg('+', path)
        -- Print path yanked
        print(path)
      end
      local yank_relative_path = function()
        ---@diagnostic disable-next-line: undefined-global
        local path = MiniFiles.get_fs_entry().path
        vim.fn.setreg('+', vim.fn.fnamemodify(path, ':.'))
        -- Print path yanked
        print(vim.fn.fnamemodify(path, ':.'))
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          ---@diagnostic disable-next-line: missing-fields
          vim.keymap.set('n', 'gy', yank_full_path, { buffer = args.data.buf_id })
          ---@diagnostic disable-next-line: missing-fields
          vim.keymap.set('n', 'gY', yank_relative_path, { buffer = args.data.buf_id })
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesWindowOpen',
        callback = function(args)
          local win_id = args.data.win_id

          -- Customize window-local settings
          -- vim.wo[win_id].winblend = 50
          local config = vim.api.nvim_win_get_config(win_id)
          config.border, config.title_pos = 'rounded', 'left'
          vim.api.nvim_win_set_config(win_id, config)
        end,
      })
    end,
  },

  {
    'echasnovski/mini.pick',
    dependencies = { 'echasnovski/mini.extra' },
    cmd = { 'Pick' },
    keys = { '<Leader>f' },
    config = function()
      require('mini.pick').setup({
        mappings = {
          scroll_down = '<C-j>',
          scroll_left = '<C-h>',
          scroll_right = '<C-l>',
          scroll_up = '<C-k>',
          move_down = '<M-j>',
          move_up = '<M-k>',
          delete_char_right = '<C-d>',
        },
        window = {
          config = { border = 'rounded' },
        },
      })

      require('core.maps').mini_pick()
    end,
  },

  -- mini.extras (作为 mini.pick/mini.ai 的依赖并由其加载)
  {
    'echasnovski/mini.extra',
    opts = {},
  },

  {
    'echasnovski/mini.cursorword',
    event = { 'BufNewFile', 'BufReadPost' },
    opts = {},
  },

  {
    'echasnovski/mini.move',
    keys = {
      { '<M-j>', mode = { 'n', 'v' }, desc = 'MiniMove Down' },
      { '<M-k>', mode = { 'n', 'v' }, desc = 'MiniMove Up' },
      { '<M-l>', mode = { 'n', 'v' }, desc = 'MiniMove Right' },
      { '<M-h>', mode = { 'n', 'v' }, desc = 'MiniMove Left' },
    },
    opts = {},
  },

  {
    'echasnovski/mini.ai',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('mini.ai').setup({
        mappings = {
          -- Main textobject prefixes
          around = 'a',
          inside = 'i',

          -- Next/last textobjects
          around_next = 'an',
          inside_next = 'in',
          around_last = 'al',
          inside_last = 'il',

          -- Move cursor to corresponding edge of `a` textobject
          goto_left = '[',
          goto_right = ']',
        },
        custom_textobjects = {
          -- treesitter-textobject
          F = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
          c = require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
          o = require('mini.ai').gen_spec.treesitter({
            a = { '@conditional.outer', '@loop.outer' },
            i = { '@conditional.inner', '@loop.inner' },
          }),
          -- Mini.Extra
          B = require('mini.extra').gen_ai_spec.buffer(),
          D = require('mini.extra').gen_ai_spec.diagnostic(),
          I = require('mini.extra').gen_ai_spec.indent(),
          L = require('mini.extra').gen_ai_spec.line(),
          N = require('mini.extra').gen_ai_spec.number(),
        },
      })
    end,
  },

  {
    'echasnovski/mini.surround',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      mappings = {
        add = 'ms',
        delete = 'md',
        find = 'mf',
        find_left = 'mF',
        highlight = 'mh',
        replace = 'mr',
        update_n_lines = 'mn',

        suffix_last = 'l',
        suffix_next = 'n',
      },
    },
  },
}
