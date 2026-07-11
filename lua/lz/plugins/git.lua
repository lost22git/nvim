-- [nfnl] fnl/lz/plugins/git.fnl
return {{"lewis6991/gitsigns.nvim", event = "VeryLazy", opts = {numhl = true, on_attach = require("core.maps").gitsigns}}}
