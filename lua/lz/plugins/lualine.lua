local M = {
  'nvim-lualine/lualine.nvim',
  enabled = not vim.g.vscode,
  -- event = { 'BufRead', 'BufNewFile' },
  event = { 'VeryLazy' },
}

function M.config()
  local lualine = require('lualine')
  local U = require('core.utils')
  lualine.setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
      disabled_filetypes = {},
      globalstatus = true, -- 全局共用一个状态栏
      -- section_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      component_separators = '',
    },
    sections = {
      lualine_a = {
        -- vim mode
        'mode'
      },
      lualine_b = {
        -- git 分支
        'branch',
        -- git diff
        'diff'
      },
      lualine_c = {
        -- 诊断信息
        {
          'diagnostics',
          sources = { "nvim_diagnostic" },
          symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' }
        },
        -- 文件名
        {
          'filename',
          file_status = true, -- displays file status (readonly status, modified status)
          path = 1,           -- 0 = just filename, 1 = relative path, 2 = absolute path
          -- color = { gui = 'italic' },
          align = 'center',
        }
      },
      lualine_x = {
        -- 当前激活的 lsp clients
        {
          U.get_buf_lsp_clients_name,
          ---@diagnostic disable-next-line: unused-local
          color = function(section) return U.get_lualine_hl_group('b') end
        },

        -- 光标位置
        'location',
        -- 光标位置处于当前文件的%进度
        'progress',
        -- 文件编码
        'encoding',
        -- 文件换行符
        {
          'fileformat',
          symbols = {
            -- icons_enabled = true 下才会生效
            unix = 'lf',
            dos = 'crlf',
            mac = 'lf',
          },
        },
      },
      lualine_y = {
        -- 插件状态
        {
          function()
            local stats = require('lazy').stats()
            return string.format('%s/%s', stats.loaded, stats.count)
          end,
          cond = function() return pcall(require, 'lazy') end,
          -- color = { bg = '#d7af00', fg = '#000000' },
        },
        -- 当前 theme
        {
          function()
            return vim.g.colors_name
          end
        },
      },
      lualine_z = {
        -- -- 文件类型
        'filetype',
      }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 0            -- 0 = just filename, 1 = relative path, 2 = absolute path
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

return M
