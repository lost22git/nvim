local M = {
  "folke/noice.nvim",
  -- enabled = function() return not require('core.utils').is_gui() end,
  keys = { "<M-9>" },
  event = { "VeryLazy" },
  -- event = { "BufRead", "CmdLineEnter" },
}

function M.config()
  local noice = require('noice')

  noice.setup {
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
      opts = {}, -- global options for the cmdline. See section on views
      ---@type table<string, CmdlineFormat>
      format = {
        -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
        -- view: (default is cmdline view)
        -- opts: any options passed to the view
        -- icon_hl_group: optional hl_group for the icon
        -- title: set to anything or empty string to hide
        cmdline = { pattern = "^:", icon = "命令", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = "搜索 ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = "搜索 ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "运行", lang = "bash" },
        lua = { pattern = "^:%s*lua%s+", icon = "lua", lang = "lua" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "帮助" },
        input = {}, -- Used by input()
        -- lua = false, -- to disable a format, set to `false`
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
            { find = 'Error',  error = false },
            { min_height = 10, error = true },
            { min_width = 50,  error = true },
          }
        }
      },
    },
  }

  require('core.maps').noice()
end

return M
