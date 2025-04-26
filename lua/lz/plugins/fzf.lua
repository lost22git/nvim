return {
  'ibhagwan/fzf-lua',
  cmd = { 'FzfLua' },
  opts = {
    fzf_colors = true,
    winopts = {
      backdrop = vim.g.LC.backdrop,
      preview = { hidden = true },
    },
  },
}
