local M = {}

function M.tokyonight()
  local tn = require('tokyonight')
  tn.setup {
    style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
    light_style = "day", -- The theme is used when the background is set to light
    transparent = true, -- Enable this to disable setting the background color
    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
    styles = {
      -- Style to be applied to different syntax groups
      -- Value is any valid attr-list value for `:help nvim_set_hl`
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = "transparent", -- style for sidebars, see below
      floats = "transparent", -- style for floating windows
    },
    sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
    day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
    hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
    dim_inactive = true, -- dims inactive windows
    lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold

    --- You can override specific color groups to use other groups or a hex color
    --- function will be called with a ColorScheme table
    ---@param colors ColorScheme
    ---@diagnostic disable-next-line: unused-local
    on_colors = function(colors) end,

    --- You can override specific highlights to use other groups or a hex color
    --- function will be called with a Highlights and ColorScheme table
    ---@param highlights Highlights
    ---@param colors ColorScheme
    ---@diagnostic disable-next-line: unused-local
    on_highlights = function(highlights, colors) end,
  }
  vim.cmd [[colorscheme tokyonight]]
end

function M.github()
  require("github-theme").setup({
    transparent = true,
    theme_style = "dark_default", -- dark | dimmed | dark_default | dark_colorblind | light | light_default | light_colorblind
    comment_style = "italic",
    keyword_style = "italic",
    function_style = "italic",
    variable_style = "italic",
    sidebars = { "qf", "vista_kind", "terminal", "packer" },

    -- Change the "hint" color to the "orange" color, and make the "error" color bright red
    colors = { hint = "orange", error = "#ff0000" },

    -- Overwrite the highlight groups
    overrides = function(c)
      return {
        htmlTag = { fg = c.red, bg = "#282c34", sp = c.hint, style = "underline" },
        DiagnosticHint = { link = "LspDiagnosticsDefaultHint" },
        -- this will remove the highlight groups
        TSField = {},
      }
    end
  })
end

function M.vscode()
  local code = require('vscode')
  local c = require('vscode.colors')
  code.setup {
    transparent = true,

    italic_comments = true,

    disable_nvimtree_bg = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {
      vscLineNumber = '#FFFFFF',
    },

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
      -- this supports the same val table as vim.api.nvim_set_hl
      -- use colors from this colorscheme by requiring vscode.colors!
      Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
    }
  }
end

return M
