local M = {
  "nvim-lualine/lualine.nvim",
  enabled = not vim.g.vscode,
  event = { "VeryLazy" },
}

function M.config()
  local lualine = require("lualine")
  local U = require("core.utils")
  lualine.setup({
    options = {
      icons_enabled = false,
      theme = "auto",
      disabled_filetypes = {},
      globalstatus = true, -- 全局共用一个状态栏
      -- section_separators = { left = '', right = '' },
      section_separators = { left = "", right = "" },
      component_separators = "",
    },
    sections = {
      lualine_a = {
        -- vim mode
        {
          "mode",
          fmt = function(str)
            return str:sub(1, 1)
          end,
        },
      },
      lualine_b = {
        -- git 分支
        "branch",
        -- git diff
        "diff",
      },
      lualine_c = {
        -- 诊断信息
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = " ", warn = " ", info = " ", hint = " " },
        },
        -- 文件名
        {
          "filename",
          file_status = true, -- displays file status (readonly status, modified status)
          path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          align = "center",
        },
      },
      lualine_x = {
        -- 光标位置
        "location",
        -- 光标位置处于当前文件的%进度
        "progress",
        -- 文件编码
        "encoding",
        -- 文件换行符
        {
          "fileformat",
          fmt = function(fmt)
            return fmt == "dos" and "crlf" or "lf"
          end,
        },
        -- 当前激活的 lsp clients
        {
          U.get_buf_lsp_clients_name,
          ---@diagnostic disable-next-line: unused-local
          color = function(section)
            return U.get_lualine_hl_group("b")
          end,
        },
      },
      lualine_y = {
        -- 插件 count
        {
          function()
            local stats = require("lazy").stats()
            return string.format("%s/%s", stats.loaded, stats.count)
          end,
          cond = function()
            return pcall(require, "lazy")
          end,
        },
        -- 当前 theme
        {
          function()
            return vim.g.colors_name or "default"
          end,
        },
      },
      lualine_z = {
        "filetype",
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          "filename",
          file_status = true, -- displays file status (readonly status, modified status)
          path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
        },
      },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {},
    --extensions = { 'fugitive' }
  })
end

return M
