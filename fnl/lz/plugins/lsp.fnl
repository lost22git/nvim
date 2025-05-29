(import-macros {: usercmd! : autocmd!} :config.macros)

(local {: list_includes
        : get_mason_path
        : lsp_server_package_path
        : lsp_with_server
        : lsp_on_attach
        : lsp_capabilities} (require :core.utils))

(fn create_LuaLibsReload []
  (fn callback [input]
    (local libs
           {:vim [vim.env.VIMRUNTIME "${3rd}/luv/library"]
            :all ["${3rd}/luv/library"
                  (unpack (vim.api.nvim_get_runtime_file "" true))]})
    (local [mode force] (vim.fn.split (. input.fargs 1) "-" false))
    (local (new_libs old_libs) (values (. libs mode) vim.g.nvim_lua_libs))
    (if (and (not= force :force) (list_includes old_libs new_libs))
        (vim.notify "[LuaLibsReload] libs have already loaded.")
        (do
          (set vim.g.nvim_lua_libs new_libs)
          (vim.cmd "LspRestart lua_ls"))))

  (usercmd! :LuaLibsReload callback
            {:nargs 1 :complete #[:vim :all :vim-force :all-force]}))

(local lua_conditional_settings
       [{:match (fn [nvim_config_path workspace_path]
                  (or (not workspace_path)
                      (= nvim_config_path
                         (workspace_path:sub 1 (length nvim_config_path)))
                      (not (or (vim.uv.fs_stat (.. workspace_path
                                                   "/.luarc.json"))
                               (vim.uv.fs_stat (.. workspace_path
                                                   "/.luarc.jsonc"))))))
         :config (fn [client]
                   (print "lua_ls load nvim lua libs.")
                   (set vim.g.nvim_lua_libs
                        (or vim.g.nvim_lua_libs
                            [vim.env.VIMRUNTIME "${3rd}/luv/library"]))
                   (set client.config.settings.Lua
                        (vim.tbl_deep_extend :force client.config.settings.Lua
                                             {:codeLens {:enable false}
                                              :runtime {:version :LuaJIT}
                                              :workspace {:checkThirdParty false
                                                          :library vim.g.nvim_lua_libs}}))
                   (create_LuaLibsReload))}])

[{1 "neovim/nvim-lspconfig"
  :cmd [:LspInfo :LspStart :LspLog]
  :dependencies [{1 "deathbeam/lspecho.nvim" :opts {}}]
  :config (fn []
            (vim.diagnostic.config {:severity_sort true
                                    :virtual_text false
                                    :virtual_lines {:current_line true}})
            (vim.lsp.config "*"
                            {:root_markers [".git"]
                             :capabilities (lsp_capabilities)})
            (autocmd! :LspAttach
                      {:callback #(-> $.data.client_id
                                      (vim.lsp.get_client_by_id)
                                      (assert)
                                      (lsp_on_attach $.buf))})

            (fn get_nvim_config_path []
              (let [path (vim.fn.stdpath :config)
                    path1 (case (type path)
                            :table (. path 1)
                            _ (tostring path))]
                (vim.uv.fs_realpath path1)))

            (fn get_workspace_path [client]
              (when client.workspace_folders
                (vim.uv.fs_realpath (. client.workspace_folders 1 :name))))

            ;; :help lspconfig-all
            (local lspconfig (require :lspconfig))
            ;; Lua
            (lspconfig.lua_ls.setup {:on_init (fn [client]
                                                ;; nvim_config_path
                                                (local nvim_config_path
                                                       (get_nvim_config_path))
                                                (print "lua_ls nvim config path:"
                                                       nvim_config_path)
                                                ;; workspace_path
                                                (local workspace_path
                                                       (get_workspace_path client))
                                                (print "lua_ls workspace path:"
                                                       workspace_path)
                                                ;; default settings
                                                (set client.config.settings.Lua
                                                     {:codeLens {:enable true}
                                                      :completion {:callSnippet :Replace}
                                                      :telemetry {:enable false}
                                                      :workspace {:checkThirdParty false
                                                                  :library {}}})
                                                ;; conditional settings
                                                (each [_ s (ipairs lua_conditional_settings)]
                                                  (when (s.match nvim_config_path
                                                                 workspace_path)
                                                    (s.config client)
                                                    (lua "break")))
                                                (print "lua_ls settings:"
                                                       (vim.inspect client.config.settings.Lua)))})
            ;; Kulala 
            (lspconfig.kulala_ls.setup {})
            ;; Markdown ; (lspconfig.marksman.setup {})
            ;; Dockerfile
            (lsp_with_server "docker-langserver"
                             #(lspconfig.dockerls.setup {:cmd [$ "--stdio"]}))
            ;; JSON
            (lspconfig.jsonls.setup {})
            ;; TOML
            (lspconfig.taplo.setup {})
            ;; XML
            (lspconfig.lemminx.setup {})
            ;; YAML
            (lspconfig.yamlls.setup {})
            ;; Nushell
            (lspconfig.nushell.setup {})
            ;; Powershell
            (lspconfig.powershell_es.setup {:bundle_path (lsp_server_package_path "powershell-editor-services")})
            ;; Deno  for js jsx ts tsx ; (lspconfig.denols.setup {})
            ;; Typescript
            (lspconfig.vtsls.setup {})
            ;; Html
            (lspconfig.html.setup {})
            ;; Htmx
            (lsp_with_server "htmx-lsp" #(lspconfig.htmx.setup {:cmd [$]}))
            ;; Tailwindcss
            (lsp_with_server "tailwindcss-language-server"
                             #(lspconfig.tailwindcss.setup {:cmd [$ "--stdio"]
                                                            :root_dir (fn [fname]
                                                                        (local patterns
                                                                               ["tailwind.config.js"
                                                                                "tailwind.config.cjs"
                                                                                "tailwind.config.mjs"
                                                                                "tailwind.config.ts"])
                                                                        (vim.fs.root fname
                                                                                     patterns))}))
            ;; SVELTE  (requires typescript-language-server)
            (lspconfig.svelte.setup {})
            ;; Clojure
            (lsp_with_server "clojure-lsp"
                             #(lspconfig.clojure_lsp.setup {:cmd [$]
                                                            :root_dir (fn [fname]
                                                                        (local patterns
                                                                               ["project.clj"
                                                                                "deps.edn"
                                                                                "build.boot"
                                                                                "shadow-cljs.edn"
                                                                                "bb.edn"])
                                                                        (vim.fs.root fname
                                                                                     patterns))}))
            ;; Crystal
            (lspconfig.crystalline.setup {})
            ;; Dart
            (lspconfig.dartls.setup {:root_dir (fn [fname]
                                                 (local patterns
                                                        ["pubspec.yaml" ".git"])
                                                 (vim.fs.root fname patterns))})
            ;; Elixir
            (lsp_with_server "elixir-ls" #(lspconfig.elixirls.setup {:cmd [$]}))
            ;; Fennel 
            (lspconfig.fennel_ls.setup {})
            ;; Flix
            (local configs (require :lspconfig.configs))
            (set configs.flix
                 {:default_config {:cmd ["flix" "lsp"]
                                   :filetypes [:flix]
                                   :root_dir #(vim.fs.root $ [:flix.toml :.git])}})
            (lspconfig.flix.setup {})
            ;; Gleam
            (lspconfig.gleam.setup {:root_dir (fn [fname]
                                                (local patterns
                                                       ["gleam.toml" ".git"])
                                                (vim.fs.root fname patterns))})
            ;; Gradle
            (lspconfig.gradle_ls.setup {})
            ;; Go
            (lspconfig.gopls.setup {})
            ;; Julia
            (lspconfig.julials.setup {:on_new_config (fn [new_config _]
                                                       (case (vim.fn.expand "~/.julia/environments/nvim-lspconfig/bin/julia")
                                                         (where julia_bin
                                                                (-> (vim.uv.fs_stat julia_bin)
                                                                    (?. :type)
                                                                    (= :file)))
                                                         (tset new_config.cmd 1
                                                               julia_bin)))})
            ;; Koka
            (lspconfig.koka.setup {})
            ;; Nim
            (lspconfig.nim_langserver.setup {})
            ;; OCaml
            (lspconfig.ocamllsp.setup {})
            ;; Odin
            (lspconfig.ols.setup {})
            ;; Racket
            (lspconfig.racket_langserver.setup {})
            ;; Raku
            (lspconfig.raku_navigator.setup {:cmd ["raku-navigator" "--stdio"]})
            ;; Roc
            (lspconfig.roc_ls.setup {})
            ;; Swift
            (lspconfig.sourcekit.setup {})
            ;; V
            (lspconfig.vls.setup {})
            ;; Zig
            (lspconfig.zls.setup {:settings {:zls {:enable_snippets true
                                                   :enable_argument_placeholders false
                                                   :highlight_global_var_declarations true}}}))}
 {1 "williamboman/mason.nvim"
  :cmd :Mason
  :opts {:install_root_dir (get_mason_path)
         :PATH :prepend
         :ui {:backdrop vim.g.zz.backdrop}}}]
