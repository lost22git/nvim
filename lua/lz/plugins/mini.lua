return {
  -- 文件管理 mini.files
  {
    'echasnovski/mini.files',
    keys = { '<M-1>', '<M-2>' },
    version = false,
    config = function()
      require('mini.files').setup {
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
          close       = 'q',
          go_in       = 'l',
          go_in_plus  = 'L',
          go_out      = 'h',
          go_out_plus = 'H',
          reset       = '<BS>',
          show_help   = 'g?',
          synchronize = '=',
          trim_left   = '<',
          trim_right  = '>',
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
      }
      require('core.maps').mini_files()
    end
  },

  -- mini.pick
  {
    'echasnovski/mini.pick',
    version = false,
    enabled = vim.g.picker == 'mini.pick',
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
      require('mini.pick').setup {
        mappings = {
          scroll_down  = '<C-j>',
          scroll_left  = '<C-h>',
          scroll_right = '<C-l>',
          scroll_up    = '<C-k>',
          move_down    = '<M-j>',
          move_up      = '<M-k>',
        }
      }
      require('core.maps').mini_pick()
    end
  },

  -- mini.extras (作为 mini.pick 的依赖并由其加载)
  {
    'echasnovski/mini.extra',
    version = false,
    config = function()
      require('mini.extra').setup {}
    end
  },

  -- mini.visits (由 mini.extra 加载)
  {
    'echasnovski/mini.visits',
    version = false,
    config = function()
      require('mini.visits').setup {}
    end,
  },

  -- mini.indent
  {
    'echasnovski/mini.indentscope',
    event = { "BufReadPost", "BufNewFile" },
    version = false,
    config = function()
      require('mini.indentscope').setup {}
    end,
  },

  -- mini.surround
  {
    'echasnovski/mini.surround',
    version = false,
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require("mini.surround").setup {
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
      }
    end
  }

}
