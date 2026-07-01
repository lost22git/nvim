(import-macros {: call! : on!} :config.macros)

(local {: lsp_with_server} (require :core.utils))

(vim.diagnostic.config {:severity_sort true
                        :virtual_text false
                        ;; :virtual_lines {:current_line true}
                        :jump {:on_jump (fn [_ bufid]
                                          (vim.diagnostic.open_float {:bufnr bufid
                                                                      :scope "cursor"
                                                                      :focus false}))}})

(fn on_attach [client bufid]
  ;; Load custom lsp mappings
  (call! :core.maps :lsp bufid)
  ;; Enable lsp completion when no blink.cmp
  (let [(has_blink_cmp _) (pcall require :blink.cmp)]
    (when (not has_blink_cmp)
      (pcall vim.lsp.completion.enable true client.id bufid {:autotrigger true})))
  ;; Enable lsp codelens
  (pcall vim.lsp.codelens.enable true))

(on! :LspAttach {:desc "[LSP] LspAttach"
                 :callback (fn [{:data {: client_id} :buf bufid}]
                             (local client
                                    (assert (vim.lsp.get_client_by_id client_id)))
                             (on_attach client bufid)
                             nil)})

(fn capabilities []
  (let [opts {:textDocument {:semanticTokens {:multilineTokenSupport true}}}
        (has_blink_cmp blink_cmp) (pcall require :blink.cmp)]
    (if has_blink_cmp
        (blink_cmp.get_lsp_capabilities opts)
        (vim.tbl_deep_extend :force (vim.lsp.protocol.make_client_capabilities)
                             opts))))

(vim.lsp.config "*" {:root_markers [".git"] :capabilities (capabilities)})

;; crystal
(vim.lsp.config :liger
                {:cmd ["liger"]
                 :filetypes [:crystal]
                 :root_markers [:shard.yml :.git]})

;; elixir
(lsp_with_server :elixir-ls #(vim.lsp.config :elixirls {:cmd [$]}))

;; flix
(vim.lsp.config :flix {:cmd ["flix" "lsp"]
                       :filetypes [:flix]
                       :root_markers [:flix.toml]})

;; nim
(vim.lsp.config :nim_langserver
                {:settings {:nim {:inlayHints {:exceptionHints {:enable false}}}}})

;; raku
(vim.lsp.config :raku_navigator {:cmd ["raku-navigator" "--stdio"]})

(vim.lsp.enable [:fennel_ls])
