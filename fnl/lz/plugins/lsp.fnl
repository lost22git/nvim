(local {: get_mason_path : lsp_with_server} (require :core.utils))

[{1 "neovim/nvim-lspconfig"
  ;; :cmd :LspStart
  :lazy false
  :config (fn []
            ;; crystal
            (vim.lsp.config :liger
                            {:cmd ["liger"]
                             :filetypes [:crystal]
                             :root_markers [:shard.yml :.git]})
            ;; elixir
            (lsp_with_server :elixir-ls #(vim.lsp.config :elixirls {:cmd [$]}))
            ;; flix
            (vim.lsp.config :flix
                            {:cmd ["flix" "lsp"]
                             :filetypes [:flix]
                             :root_markers [:flix.toml]})
            ;; nim_langserver
            (vim.lsp.config :nim_langserver
                            {:settings {:nim {:inlayHints {:exceptionHints {:enable false}}}}})
            ;; raku_navigator
            (vim.lsp.config :raku_navigator {:cmd ["raku-navigator" "--stdio"]})
            ;; zls
            (vim.lsp.config :zls
                            {:settings {:zls {:enable_snippets true
                                              :enable_argument_placeholders false
                                              :highlight_global_var_declarations true}}})
            (vim.lsp.enable [:fennel_ls]))}
 {1 "deathbeam/lspecho.nvim" :event :LspAttach :opts {}}
 {1 "rachartier/tiny-inline-diagnostic.nvim"
  :event :LspAttach
  :opts {:preset :ghost}}
 {1 "williamboman/mason.nvim"
  :cmd :Mason
  :opts {:install_root_dir (get_mason_path)
         :PATH :prepend
         :ui {:backdrop vim.g.zz.backdrop}}}]
