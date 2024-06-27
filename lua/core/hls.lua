vim.cmd [[
    highlight Pmenu ctermbg=none guibg=none
]]

if vim.g.transparent then
  vim.cmd [[
    highlight Normal ctermbg=none guibg=none
    highlight NormalFloat ctermbg=none guibg=none
  ]]
end
