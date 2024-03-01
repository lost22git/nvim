local M = {
  "folke/noice.nvim",
  keys = { "<M-9>" },
  event = { "VeryLazy" },
  -- event = { "BufRead", "CmdLineEnter" },
}

function M.config()
  local noice = require('noice')

  noice.setup {
    cmdline = {
      enabled = true,
      -- view = "cmdline_popup",
      view = "cmdline",
      opts = {},
      ---@type table<string, CmdlineFormat>
      format = {
        cmdline = { pattern = "^:", icon = "命令", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = "搜索 ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = "搜索 ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "运行", lang = "bash" },
        lua = { pattern = "^:%s*lua%s+", icon = "lua", lang = "lua" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "帮助" },
        input = {}, -- Used by input()
      },
    },
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
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false,
    },
    routes = {
      {
        view = 'split',
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
    },
  }

  require('core.maps').noice()
end

return M
