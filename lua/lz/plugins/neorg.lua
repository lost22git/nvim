local M = {
  'nvim-neorg/neorg',
  enabled = false and not vim.g.vscode,
  build = ':Neorg sync-parsers', -- This is the important bit!
  ft = 'norg',
}

function M.config()
  -- https://github.com/nvim-neorg/neorg
  local neorg = require('neorg')
  neorg.setup({
    load = {
      ['core.defaults'] = {},
      ['core.norg.concealer'] = {},
      ['core.norg.qol.toc'] = {},
      ['core.presenter'] = {
        config = {
          zen_mode = 'zen-mode',
        },
      },
      ['core.norg.completion'] = {
        config = {
          engine = 'nvim-cmp',
        },
      },
      ['core.integrations.nvim-cmp'] = {},
      ['core.export'] = {},

      --
      ['core.keybinds'] = {
        config = {
          default_keybinds = false,
          hook = function(keybinds)
            keybinds.remap_event('norg', 'n', 'gtt', 'core.norg.qol.todo_items.todo.task_cycle')
          end,
        },
      },
    },
  })
end

return M
