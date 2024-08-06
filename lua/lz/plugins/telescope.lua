local fzf = {
  'nvim-telescope/telescope-fzf-native.nvim',
  build =
  'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
  config = function()
    require('telescope').load_extension('fzf')
  end
}

local M = {
  'nvim-telescope/telescope.nvim',
  enabled = vim.g.picker == 'telescope' and (not vim.g.vscode),
  tag = '0.1.4',
  cmd = { "Telescope" },
  keys = { "<Leader>ff", "<Leader>fg", "<Leader>fm", "<Leader>fe", "<leader>bb", "<Leader>fa", "<Leader>ft", "<Leader>fs" },
  dependencies = {
    'nvim-lua/plenary.nvim',
    fzf,
  },
}

function M.config()
  local maps = require("core.maps")
  local tel = require("telescope")

  tel.setup {
    defaults = {
      layout_strategy = 'vertical',
      layout_config = { height = 0.95 },
      mappings = maps.telescope_default_mapping(),
    },
    extensions = {
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

return M
