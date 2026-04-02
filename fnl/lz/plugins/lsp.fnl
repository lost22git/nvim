(local {: get_mason_path} (require :core.utils))

[{1 "neovim/nvim-lspconfig" :lazy false}
 {1 "deathbeam/lspecho.nvim" :event :LspAttach :opts {}}
 {1 "rachartier/tiny-inline-diagnostic.nvim"
  :event :LspAttach
  :opts {:preset :ghost}}
 {1 "williamboman/mason.nvim"
  :cmd :Mason
  :opts {:install_root_dir (get_mason_path)
         :PATH :prepend
         :ui {:backdrop vim.g.zz.backdrop}}}]
