(import-macros {: has : autocmd} :config.macros)

{1 "mfussenegger/nvim-jdtls"
 :dependencies ["neovim/nvim-lspconfig"]
 :cmd :JdtStart
 :config (fn []
           ;; See `:help vim.lsp.start_client` for an overview of the supported `config` options.
           (local {: lsp_capabilities
                   : lsp_on_attach
                   : lsp_server_package_path}
                  (require :core.utils))
           (local jdtls_root (lsp_server_package_path :jdtls))
           (local jdtls_jar
                  (assert (vim.fn.globpath (.. jdtls_root "/plugins")
                                           "org.eclipse.equinox.launcher_*.jar")
                          "[nvim-jdtls] jdtls jar not found"))
           (local lombok_jar (.. jdtls_root "/lombok.jar"))
           (local jdtls_config_dir
                  (.. jdtls_root
                      (if (has :win32) "/config_win"
                          (has :mac) "/config_mac"
                          "/config_linux")))
           (local workspace_root (vim.fs.normalize "~/.cache/jdtls/workspace"))

           (fn start_or_attach []
             (local project_root
                    (assert (vim.fs.root 0 ["mvnw" "gradlew" ".git"])
                            "[nvim-jdtls] project root not found"))
             (local project_name (vim.fn.fnamemodify project_root ":p:h:t"))
             (local workspace_dir (.. workspace_root "/" project_name))
             (local opts
                    {:capabilities (lsp_capabilities)
                     :on_attach lsp_on_attach
                     ;; The command that starts the language server
                     ;; See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
                     :cmd ["java"
                           ;; 💀
                           "-Declipse.application=org.eclipse.jdt.ls.core.id1"
                           "-Dosgi.bundles.defaultStartLevel=4"
                           "-Declipse.product=org.eclipse.jdt.ls.core.product"
                           "-Dlog.protocol=true"
                           "-Dlog.level=ALL"
                           "-Xmx1g"
                           "--add-modules=ALL-SYSTEM"
                           "--add-opens"
                           "java.base/java.util=ALL-UNNAMED"
                           "--add-opens"
                           "java.base/java.lang=ALL-UNNAMED"
                           ;; 💀
                           (.. "-javaagent:" lombok_jar)
                           ;; 💀
                           "-jar"
                           jdtls_jar
                           ;; 💀
                           "-configuration"
                           jdtls_config_dir
                           ;; 💀
                           "-data"
                           workspace_dir]
                     :root_dir project_root
                     ;; Here you can configure eclipse.jdt.ls specific settings
                     ;; See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                     ;; for a list of options
                     :settings {:java {:codeGeneration {:hashCodeEquals {:useJava7Objects true}
                                                        :toString {:template "${object.className}{${member.name()}=${member.value} ${otherMembers}}"}
                                                        :useBlocks true}
                                       :contentProvider {:preferred "fernflower"}
                                       :format {:enabled true}
                                       :implementationsCodeLens {:enabled true}
                                       :inlayHints {:enabled true}
                                       :referencesCodeLens {:enabled true}
                                       :saveActions {:organizeImports true}
                                       :signatureHelp {:enabled true}}}
                     ;; Language server `initializationOptions`
                     ;; You need to extend the `bundles` with paths to jar files
                     ;; if you want to use additional eclipse.jdt.ls plugins.
                     ;;
                     ;; See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
                     ;;
                     ;; If you don"t plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
                     :init_options {:bundles {}}
                     :flags {:allow_incremental_sync true}})
             ((. (require :jdtls) :start_or_attach) opts))

           (when (= :java vim.bo.filetype) (start_or_attach))
           (autocmd :FileType
                    {:group (vim.api.nvim_create_augroup :JdtStartOrAttach {})
                     :pattern :java
                     :callback start_or_attach}))}
