(import-macros {: autocmd! : usercmd!} :config.macros)

(local {: get_mason_path : lsp_on_attach : lsp_capabilities : lsp_with_server}
       (require :core.utils))

[{1 "neovim/nvim-lspconfig"
  :cmd [:LspInfo :LspStart :LspLog]
  :dependencies [{1 "deathbeam/lspecho.nvim" :opts {}}
                 {1 "rachartier/tiny-inline-diagnostic.nvim"
                  :opts {:preset :ghost}}]
  :config (fn []
            (vim.diagnostic.config {:severity_sort true
                                    :virtual_text false
                                    :float true
                                    :jump {:float true}
                                    ;; :virtual_lines {:current_line true}
                                    })
            (vim.lsp.config "*"
                            {:root_markers [".git"]
                             :capabilities (lsp_capabilities)})
            (autocmd! :LspAttach
                      {:callback #(-> $.data.client_id
                                      (vim.lsp.get_client_by_id)
                                      (assert)
                                      (lsp_on_attach $.buf))})
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
                             :dartls
                             :emmylua_ls
                             :fennel_ls
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
                             ;; === FE ===
                             :html
                             :htmx]))}
 {1 "williamboman/mason.nvim"
  :cmd :Mason
  :opts {:install_root_dir (get_mason_path)
         :PATH :prepend
         :ui {:backdrop vim.g.zz.backdrop}}}]
