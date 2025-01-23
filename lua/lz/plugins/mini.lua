return {

  ----------------
  -- mini.icons --
  ----------------

  {
    'echasnovski/mini.icons',
    opts = {},
    specs = {
      { 'nvim-tree/nvim-web-devicons', enabled = false, optional = true },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      package.preload['nvim-web-devicons'] = function()
        -- needed since it will be false when loading and mini will fail
        package.loaded['nvim-web-devicons'] = {}
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
  },

  ----------------
  -- mini.files --
  ----------------

  {
    'echasnovski/mini.files',
    enabled = not vim.g.vscode,
    keys = { '<M-1>', '<M-2>' },
    version = false,
    config = function()
      require('mini.files').setup({
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
      })
      require('core.maps').mini_files()

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesWindowOpen',
        callback = function(args)
          local win_id = args.data.win_id

          -- Customize window-local settings
          -- vim.wo[win_id].winblend = 50
          local config = vim.api.nvim_win_get_config(win_id)
          config.border, config.title_pos = 'solid', 'left'
          vim.api.nvim_win_set_config(win_id, config)
        end,
      })
    end,
  },

  ---------------
  -- mini.pick --
  ---------------

  {
    'echasnovski/mini.pick',
    version = false,
    enabled = not vim.g.vscode,
    dependencies = { 'echasnovski/mini.extra' },
    keys = {
      '<leader>ff',
      '<leader>fs',
      '<leader>bb',
      '<leader>fr',
      '<leader>fh',
      '<leader>fg',
      '<leader>fe',
      '<leader>fv',
    },
    config = function()
      require('mini.pick').setup({
        mappings = {
          scroll_down = '<C-j>',
          scroll_left = '<C-h>',
          scroll_right = '<C-l>',
          scroll_up = '<C-k>',
          move_down = '<M-j>',
          move_up = '<M-k>',
        },
        window = {
          config = { border = 'solid' },
        },
      })
      require('core.maps').mini_pick()
    end,
  },

  -- mini.extras (作为 mini.pick 的依赖并由其加载)
  {
    'echasnovski/mini.extra',
    version = false,
    config = function() require('mini.extra').setup({}) end,
  },

  -- mini.visits (由 mini.extra 加载)
  {
    'echasnovski/mini.visits',
    version = false,
    config = function() require('mini.visits').setup({}) end,
  },

  -----------------
  -- mini.indent --
  -----------------

  -- {
  --   'echasnovski/mini.indentscope',
  --   version = false,
  --   enabled = not vim.g.vscode,
  --   event = { 'BufReadPost', 'BufNewFile' },
  --   config = function() require('mini.indentscope').setup({}) end,
  -- },

  -------------------
  -- mini.surround --
  -------------------

  {
    'echasnovski/mini.surround',
    version = false,
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('mini.surround').setup({
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
      })
    end,
  },

  ------------------
  -- mini.tabline --
  ------------------

  {
    'echasnovski/mini.tabline',
    version = false,
    enabled = not vim.g.vscode,
    event = { 'BufAdd', 'TabEnter' },
    config = function() require('mini.tabline').setup({}) end,
  },

  ---------------
  -- mini.move --
  ---------------
  {
    'echasnovski/mini.move',
    version = false,
    keys = { '<M-j>', '<M-k>', '<M-l>', '<M-h>' },
    config = function() require('mini.move').setup({}) end,
  },

  -------------
  -- mini.ai --
  -------------

  {
    'echasnovski/mini.ai',
    version = false,
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
      })
    end,
  },

  ---------------------
  -- mini.statusline --
  ---------------------

  {
    'echasnovski/mini.statusline',
    version = false,
    event = 'VeryLazy',
    config = function()
      require('mini.statusline').setup({
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

            local color_scheme = require('mini.icons').get('lsp', 'color') .. ' ' .. (vim.g.colors_name or 'default')

            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineLocation', strings = { location } },
              { hl = mode_hl, strings = { color_scheme, fileinfo } },
            })
          end,
          inactive = nil,
        },
        use_icons = true,
        set_vim_settings = true,
      })
    end,
  },
}
