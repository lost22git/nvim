(import-macros {: autocmd!} :config.macros)

(local {:lsp lsp_mappings} (require :core.maps))

(fn format_on_save [client bufid]
  (case (pcall require :conform)
    (where (false _) (client:supports_method :textDocument/formatting))
    (let [g (vim.api.nvim_create_augroup :lsp_format_on_save {})
          cb (partial vim.lsp.buf.format {:buffer bufid :timeout_ms 1000})]
      (vim.api.nvim_clear_autocmds {:group g :buffer bufid})
      (autocmd! :BufWritePre {:group g :buffer bufid :callback cb}))))

(fn on_attach [client bufid]
  (tset vim.bo bufid :omnifunc nil)
  (lsp_mappings bufid)
  (format_on_save client bufid)
  (pcall vim.lsp.codelens.enable true))

(autocmd! :LspAttach {:desc "[LSP] LspAttach"
                      :callback (fn [{:data {: client_id} :buf bufid}]
                                  (local client
                                         (assert (vim.lsp.get_client_by_id client_id)))
                                  (on_attach client bufid)
                                  nil)})

(fn capabilities []
  (let [cmp (require :blink.cmp)
        opts {:textDocument {:semanticTokens {:multilineTokenSupport true}}}]
    (vim.tbl_deep_extend "force" (cmp.get_lsp_capabilities) opts)))

(vim.lsp.config "*" {:root_markers [".git"] :capabilities (capabilities)})

(vim.diagnostic.config {:severity_sort true
                        :virtual_text false
                        ;; :virtual_lines {:current_line true}
                        :jump {:on_jump (fn [_ bufid]
                                          (vim.diagnostic.open_float bufid
                                                                     {:scope "cursor"
                                                                      :focurs false}))}})
