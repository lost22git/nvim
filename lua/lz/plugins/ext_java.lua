local jdtls = {
  'mfussenegger/nvim-jdtls',
  enabled = false,
  ft = { 'java' },
}

jdtls.config = function()
  local U = require('core.utils')
  require('jdtls').start_or_attach({
    cmd = { U.get_lsp_server_path('jdtls') },
    root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  })
end

local java = {
  'nvim-java/nvim-java',
  enabled = false,
  ft = { 'java' },
  dependencies = {
    'neovim/nvim-lspconfig',
  },
}

return {
  jdtls,
  java,
}
