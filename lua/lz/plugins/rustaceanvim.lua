return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
  },

  {
    "saecki/crates.nvim",
    enabled = not vim.g.vscode,
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup()
    end,
  },
}
