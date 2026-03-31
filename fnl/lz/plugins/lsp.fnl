(local {: get_mason_path : lsp_with_server} (require :core.utils))

(fn capabilities []
  (let [cmp (require :blink.cmp)
        opts {:textDocument {:semanticTokens {:multilineTokenSupport true}}}]
    (vim.tbl_deep_extend "force" (cmp.get_lsp_capabilities) opts)))

[{1 "neovim/nvim-lspconfig"
  :cmd :LspStart
  :dependencies [{1 "deathbeam/lspecho.nvim" :opts {}}
                 {1 "rachartier/tiny-inline-diagnostic.nvim"
                  :opts {:preset :ghost}}]
  :config (fn []
            (vim.lsp.config "*"
                            {:root_markers [".git"]
                             :capabilities (capabilities)})
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
            (vim.lsp.enable [:dockerls
                             :kulala_ls
                             :marksman
                             ;; === SHELL ===
                             :bashls
                             :nushell
                             :powershell_es
                             ;; === PL ===
                             :clojure_lsp
                             :elixirls
                             :dartls
                             :emmylua_ls
                             :fennel_ls
                             :fsautocomplete
                             :gleam
                             :gradle_ls
                             :gopls
                             :hls
                             :julials
                             :koka
                             :kotlin_lsp
                             :ocamllsp
                             :ols
                             :racket_langserver
                             :roc_ls
                             :rust_analyzer
                             :sourcekit
                             :ty
                             :unison
                             :v_analyzer
                             :zls
                             ;; === FE ===
                             :html
                             :htmx]))}
 {1 "williamboman/mason.nvim"
  :cmd :Mason
  :opts {:install_root_dir (get_mason_path)
         :PATH :prepend
         :ui {:backdrop vim.g.zz.backdrop}}}]
