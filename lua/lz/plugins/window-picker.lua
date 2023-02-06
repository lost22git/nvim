local M = {
  's1n7ax/nvim-window-picker',
  tag = 'v1.x',
  keys = { '<Leader>w' },
}

function M.config()
  require 'window-picker'.setup {
    autoselect_one = true,

    include_current_win = false,

    selection_chars = 'FJDKSLA;CMRUEIWOQP',

    -- whether you want to use winbar instead of the statusline
    -- "always" means to always use winbar,
    -- "never" means to never use winbar
    -- "smart" means to use winbar if cmdheight=0 and statusline if cmdheight > 0
    use_winbar = 'never', -- "always" | "never" | "smart"

    -- whether to show 'Pick window:' prompt
    show_prompt = true,

    -- if you want to manually filter out the windows, pass in a function that
    -- takes two parameters. you should return window ids that should be
    -- included in the selection
    -- EX:-
    -- function(window_ids, filters)
    --    -- filter the window_ids
    --    -- return only the ones you want to include
    --    return {1000, 1001}
    -- end
    filter_func = nil,

    -- following filters are only applied when you are using the default filter
    -- defined by this plugin. if you pass in a function to "filter_func"
    -- property, you are on your own
    filter_rules = {
      -- filter using buffer options
      bo = {
        -- if the file type is one of following, the window will be ignored
        filetype = { 'NvimTree', "neo-tree", "notify", "drex" },

        -- if the buffer type is one of following, the window will be ignored
        buftype = { 'terminal' },
      },

      -- filter using window options
      wo = {},

      -- if the file path contains one of following names, the window
      -- will be ignored
      file_path_contains = {},

      -- if the file name contains one of following names, the window will be
      -- ignored
      file_name_contains = {},
    },

    -- the foreground (text) color of the picker
    fg_color = '#ededed',

    -- if you have include_current_win == true, then current_win_hl_color will
    -- be highlighted using this background color
    current_win_hl_color = '#e35e4f',

    -- all the windows except the curren window will be highlighted using this
    -- color
    other_win_hl_color = '#0a7aca',

    -- You can change the display string in status bar.
    -- It supports '%' printf style. Such as `return char .. ': %f'` to display
    -- buffer filepath. See :h 'stl' for details.
    selection_display = function(char) return char end,
  }

  require('core.maps').window_picker()
end

return M
