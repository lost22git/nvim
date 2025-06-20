(import-macros {: autocmd! : usercmd!} :config.macros)

(local {: list_includes : get_mason_path : lsp_on_attach : lsp_capabilities}
       (require :core.utils))

(fn create_usercmd_LuaLibsReload []
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
                      (vim.startswith workspace_path nvim_config_path)
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
                   (create_usercmd_LuaLibsReload))}])

(fn get_nvim_config_path []
  (let [path (vim.fn.stdpath :config)
        path1 (case (type path)
                :table (. path 1)
                _ (tostring path))]
    (vim.uv.fs_realpath path1)))

(fn get_workspace_path [client]
  (when client.workspace_folders
    (vim.uv.fs_realpath (. client.workspace_folders 1 :name))))

[{1 "neovim/nvim-lspconfig"
  :cmd [:LspInfo :LspStart :LspLog]
  :dependencies [{1 "deathbeam/lspecho.nvim" :opts {}}]
  :config (fn []
            (vim.diagnostic.config {:severity_sort true
                                    :virtual_text false
                                    :float true
                                    :virtual_lines {:current_line true}
                                    :jump {:float true}})
            (vim.lsp.config "*"
                            {:root_markers [".git"]
                             :capabilities (lsp_capabilities)})
            (autocmd! :LspAttach
                      {:callback #(-> $.data.client_id
                                      (vim.lsp.get_client_by_id)
                                      (assert)
                                      (lsp_on_attach $.buf))})
            ;; lua_ls
            (vim.lsp.config :lua_ls
                            {:settings {:Lua {:codeLens {:enable true}
                                              :completion {:callSnippet :Replace}
                                              :telemetry {:enable false}
                                              :workspace {:checkThirdParty false
                                                          :library {}}}}
                             :on_init (fn [client]
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
                                        ;; conditional settings
                                        (each [_ s (ipairs lua_conditional_settings)]
                                          (when (s.match nvim_config_path
                                                         workspace_path)
                                            (s.config client)
                                            (lua "break")))
                                        (print "lua_ls settings:"
                                               (vim.inspect client.config.settings.Lua)))})
            ;; flix
            (vim.lsp.config :flix
                            {:cmd ["flix" "lsp"]
                             :filetypes [:flix]
                             :root_markers [:flix.toml]})
            ;; raku_navigator
            (vim.lsp.config :raku_navigator {:cmd ["raku-navigator" "--stdio"]})
            ;; tailwindcss
            (vim.lsp.config :tailwindcss
                            {:root_markers ["tailwind.config.js"
                                            "tailwind.config.cjs"
                                            "tailwind.config.mjs"
                                            "tailwind.config.ts"]})
            ;; zls
            (vim.lsp.config :zls
                            {:settings {:zls {:enable_snippets true
                                              :enable_argument_placeholders false
                                              :highlight_global_var_declarations true}}})
            (vim.lsp.enable [:emmylua_ls
                             :marksman
                             :kulala_ls
                             :dockerls
                             ;; === shell ===
                             :nushell
                             :powershell_es
                             ;; === frontend ===
                             :html
                             :htmx
                             :svelte
                             :vtsls
                             ;; === PL ===
                             :clojure_lsp
                             :crystalline
                             :dartls
                             :elixirls
                             :fennel_ls
                             :gleam
                             :gradle_ls
                             :gopls
                             :julials
                             :koka
                             :nim_langserver
                             :ocamllsp
                             :ols
                             :racket_langserver
                             :roc_ls
                             :ruff
                             :sourcekit
                             :v_analyzer]))}
 {1 "williamboman/mason.nvim"
  :cmd :Mason
  :opts {:install_root_dir (get_mason_path)
         :PATH :prepend
         :ui {:backdrop vim.g.zz.backdrop}}}]
