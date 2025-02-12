return {
  'nvim-neorg/neorg',
  version = '*',
  enabled = not vim.g.vscode,
  ft = 'norg',
  cmd = 'Neorg',
  config = function()
    require('neorg').setup({
      load = {
        ['core.defaults'] = {},
        ['core.clipboard'] = {},
        -- ['core.completion'] = {}, -- not support blink.cmp
        ['core.concealer'] = { config = { icon_preset = 'varied' } },
        ['core.dirman'] = {
          config = {
            workspaces = {
              notes = '~/code/_note/neorg',
            },
          },
        },
        ['core.export'] = {},
        ['core.export.markdown'] = {},
        ['core.highlights'] = {},
        ['core.keybinds'] = {
          config = {
            -- neorg_leader = ',',
          },
        },
        -- ['core.integrations.image'] = {},
        ['core.integrations.treesitter'] = {},
        -- ['core.latex.renderer'] = {},
        ['core.presenter'] = { config = { zen_mode = 'truezen' } },
        ['core.queries.native'] = {},
        ['core.summary'] = {},
      },
    })
  end,
}
