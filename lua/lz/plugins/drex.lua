local M = {
  'theblob42/drex.nvim',
  keys = { "<M-1>", "<M-2>" },
}

function M.config()
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

return M
