return {
  "0xstepit/flow.nvim",
  enabled = vim.g.theme == 'flow',
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    require("flow").setup{
      transparent = vim.g.transparent,
      fluo_color = "pink",
      mode = "normal",
      aggressive_spell = false,
    }
    vim.cmd.colorscheme "flow"
  end,
}
