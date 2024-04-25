local M = {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,
  enabled = vim.g.theme == 'rose-pine',
}

function M.config()
  require("rose-pine").setup({
    variant = "auto",      -- auto, main, moon, or dawn
    dark_variant = "main", -- main, moon, or dawn
    dim_inactive_windows = true,
    extend_background_behind_borders = true,

    enable = {
      terminal = true,
      legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
      migrations = true,        -- Handle deprecated options automatically
    },

    styles = {
      bold = true,
      italic = false,
      transparency = vim.g.transparent,
    },

    groups = {
      border = "muted",
      link = "iris",
      panel = "surface",

      error = "love",
      hint = "iris",
      info = "foam",
      note = "pine",
      todo = "rose",
      warn = "gold",

      git_add = "foam",
      git_change = "rose",
      git_delete = "love",
      git_dirty = "rose",
      git_ignore = "muted",
      git_merge = "iris",
      git_rename = "pine",
      git_stage = "iris",
      git_text = "rose",
      git_untracked = "subtle",

      h1 = "iris",
      h2 = "foam",
      h3 = "rose",
      h4 = "gold",
      h5 = "pine",
      h6 = "foam",
    },

    highlight_groups = {
      -- Comment = { fg = "foam" },
      -- VertSplit = { fg = "muted", bg = "muted" },
    },

    before_highlight = function(group, highlight, palette)
      -- Disable all undercurls
      -- if highlight.undercurl then
      --     highlight.undercurl = false
      -- end
      --
      -- Change palette colour
      -- if highlight.fg == palette.pine then
      --     highlight.fg = palette.foam
      -- end
    end,
  })

  local themes = {
    dark = {
    'rose-pine',
    'rose-pine-main',
    'rose-pine-moon',
    },
    light = {
    'rose-pine-dawn',
    },
  }
  local bg= vim.o.background
  vim.cmd.colorscheme(themes[bg][(vim.fn.rand() % vim.fn.len(themes[bg])) + 1])
end

return M
