local M = {
    'nvim-treesitter/nvim-treesitter-context',
    cmd = { "TSContextEnable" },
    config = function()
        require('treesitter-context').setup {}
    end
}

return M
