local M = {}

function M.lualine()
  local lualine = require('lualine')
  local U = require('core.utils')
  lualine.setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
      -- section_separators = { left = '', right = '' },
      section_separators = '',
      -- component_separators = { left = '', right = '' },
      component_separators = '',
      disabled_filetypes = {},
      globalstatus = true, -- 全局共用一个状态栏
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff' },
      lualine_c = {
        {
          'diagnostics',
          sources = { "nvim_diagnostic" },
          symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' }
        },
        {
          'filename',
          file_status = true, -- displays file status (readonly status, modified status)
          path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          color = { gui = 'italic' },
        }
      },
      lualine_x = {
        {
          U.get_buf_lsp_clients_name,
          color = function(section) return U.get_lualine_hl_group(section) end
        },
        'filetype',
        'filesize',
        'encoding',
        {
          'fileformat',
          symbols = {
            unix = 'lf',
            dos = 'crlf',
            mac = 'lf',
          },
        },
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
      } },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    --extensions = { 'fugitive' }
  }
end

function M.bufferline()
  local bufferline = require("bufferline")
  local maps = require('core.maps')

  bufferline.setup {
    options = {
      mode = "buffers",
      numbers = 'none',
      close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
      right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
      left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
      middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
      left_trunc_marker = '',
      right_trunc_marker = '',
      modified_icon = '●',
      offsets = {
        {
          filetype = "Neo-Tree",
          text = "File Explorer",
          text_align = "left",
          separator = true,
        }
      },
      always_show_bufferline = false,
      show_buffer_close_icons = false,
      show_close_icon = false,
      color_icons = true,
      ---@diagnostic disable-next-line: assign-type-mismatch
      separator_style = { '', '' }, -- slant | thick | thin | { 'any', 'any' }
      show_tab_indicators = true,
      indicator = {
        icon = '▎', -- this should be omitted if indicator style is not 'icon'
        style = 'icon',
      },
      diagnostics = 'nvim_lsp',
      ---@diagnostic disable-next-line: unused-local
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        return ''
      end,
    },
    highlights = {
    },
  }

  maps.bufferline()

end

function M.noice()
  local noice = require('noice')

  noice.setup {
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false,
    },
    routes = {
      {
        view = 'split',
        filter = {
          any = {
            { find = 'Error', error = false },
            { min_height = 10, error = true },
            { min_width = 50, error = true },
          }
        }
      },
    },
  }

  require('core.maps').noice()
end

function M.notify()
  require("notify").setup {
    background_colour = "#000000",
    stages = 'fade',
    top_down = true,
  }
end

function M.telescope()
  local maps = require("core.maps")
  local tel = require("telescope")

  tel.setup {
    defaults = {
      mappings = maps.telescope_default_mapping()
    },
    extensions = {
      file_browser = {
        theme = "dropdown",
        -- disables netrw and use telescope-file-browser in its place
        hijack_netrw = true,
        mappings = maps.telescope_file_browser_mappings()
      },
      fzf = {
        -- false will only do exact matching
        fuzzy = true,
        -- override the generic sorter
        override_generic_sorter = true,
        -- override the file sorter
        override_file_sorter = true,
        --"smart_case" | "ignore_case" | "respect_case"
        case_mode = "smart_case",
      }
    },
  }

  -- keymaps
  maps.telescope()

end

function M.telescope_fzf()
  local tel = require('telescope')
  tel.load_extension('fzf')
end

function M.telescope_file_browser()
  local tel = require("telescope")
  tel.load_extension('file_browser')
end

function M.fterm()
  local maps = require('core.maps')
  local fterm = require('FTerm')
  fterm.setup {
    ---Filetype of the terminal buffer
    ---@type string
    ft = 'FTerm',

    ---Command to run inside the terminal
    ---NOTE: if given string[], it will skip the shell and directly executes the command
    ---@type fun():(string|string[])|string|string[]
    cmd = vim.o.shell,

    ---Neovim's native window border. See `:h nvim_open_win` for more configuration options.
    border = 'single',

    ---Close the terminal as soon as shell/command exits.
    ---Disabling this will mimic the native terminal behaviour.
    ---@type boolean
    auto_close = true,

    ---Highlight group for the terminal. See `:h winhl`
    ---@type string
    hl = "Normal",

    ---Transparency of the floating window. See `:h winblend`
    ---@type integer
    blend = 0,

    ---Object containing the terminal window dimensions.
    ---The value for each field should be between `0` and `1`
    ---@type table<string,number>
    dimensions = {
      height = 0.8, -- Height of the terminal window
      width = 0.8, -- Width of the terminal window
      x = 0.5, -- X axis of the terminal window
      y = 0.5, -- Y axis of the terminal window
    },

    ---Callback invoked when the terminal exits.
    ---See `:h jobstart-options`
    ---@type fun()|nil
    on_exit = nil,

    ---Callback invoked when the terminal emits stdout data.
    ---See `:h jobstart-options`
    ---@type fun()|nil
    on_stdout = nil,

    ---Callback invoked when the terminal emits stderr data.
    ---See `:h jobstart-options`
    ---@type fun()|nil
    on_stderr = nil,
  }

  maps.fterm()
end

function M.drex()
  local maps = require("core.maps")
  require('drex.config').configure {
    icons = {
      file_default = "",
      dir_open = "",
      dir_closed = "",
      link = "",
      others = "",
    },
    colored_icons = true,
    hide_cursor = false,
    hijack_netrw = false,
    sorting = function(a, b)
      local aname, atype = a[1], a[2]
      local bname, btype = b[1], b[2]

      local aisdir = atype == 'directory'
      local bisdir = btype == 'directory'

      if aisdir ~= bisdir then
        return aisdir
      end

      return aname < bname
    end,
    drawer = {
      default_width = 30,
      window_picker = {
        enabled = true,
        labels = 'abcdefghijklmnopqrstuvwxyz',
      },
    },
    disable_default_keybindings = true,
    keybindings = maps.drex_keybindings(),
    on_enter = nil,
    on_leave = nil,
  }

  maps.drex()

  -- 默认会显示所有 drex buffers
  -- 此处关闭该功能
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('DrexNotListed', {}),
    pattern = 'drex',
    command = 'setlocal nobuflisted'
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('DrexDrawerWindow', {}),
    pattern = '*',
    callback = function(args)
      if vim.api.nvim_get_current_win() == require('drex.drawer').get_drawer_window() then
        local is_drex_buffer = function(b)
          local ok, syntax = pcall(vim.api.nvim_buf_get_option, b, 'syntax')
          return ok and syntax == 'drex'
        end
        local prev_buf = vim.fn.bufnr('#')

        if is_drex_buffer(prev_buf) and not is_drex_buffer(args.buf) then
          vim.api.nvim_set_current_buf(prev_buf)
          vim.schedule(function()
            vim.cmd([['"]]) -- restore former cursor position
          end)
        end
      end
    end
  })
end

function M.neotree()
  local nt = require('neo-tree')
  local maps = require('core.maps')
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
  nt.setup {
    window = {
      position = "left",
      width = 30,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = maps.neotree_window_mappings(),
    },
    filesystem = {
      window = {
        mappings = maps.neotree_filesystem_window_mappings(),
      },

    },
    buffers = {
      window = {
        mappings = maps.neotree_buffers_window_mappings(),
      }
    },
    git_status = {
      window = {
        position = 'float',
        mappings = maps.neotree_git_status_window_mappings(),
      }
    },
    event_handlers = {
      {
        event = "neo_tree_window_after_open",
        handler = function(args)
          if args.position == "left" or args.position == "right" then
            vim.cmd("wincmd =")
          end
        end
      },
      {
        event = "neo_tree_window_after_close",
        handler = function(args)
          if args.position == "left" or args.position == "right" then
            vim.cmd("wincmd =")
          end
        end
      }
    }
  }

  maps.neotree()
end

return M
