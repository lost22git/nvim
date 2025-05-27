(import-macros {: has! : autocmd! : nvomap!} :config.macros)

(local M {})

(fn M.generate_id []
  (.. (os.time) "-" (vim.fn.rand)))

(fn M.on_gui []
  (or vim.g.neovide vim.g.fvim_loaded vim.g.vscode))

(fn M.on_v_modes []
  (let [v_block_mode (vim.api.nvim_replace_termcodes :<C-V> true true true)
        v_modes [:v :V v_block_mode]]
    (vim.tbl_contains v_modes (vim.fn.mode))))

(fn M.get_flutter_path []
  (let [path (vim.fn.exepath "flutter")]
    (if (has! :win32) (.. path ".bat") path)))

(fn M.disable_diagnostic [bufid]
  (when (vim.diagnostic.is_enabled {:bufnr bufid})
    (pcall vim.diagnostic.enable false {:bufnr bufid})))

(fn M.get_mason_path []
  (.. (vim.fn.stdpath "data") "/mason"))

(fn M.lsp_server_package_path [name]
  (.. (M.get_mason_path) "/packages/" name))

(fn find_lsp_server_from_mason [name]
  (var path (.. (M.get_mason_path) "/bin/" name))
  (when (has! :win32) (set path (.. path ".cmd")))
  (when (= 1 (vim.fn.executable path)) path))

(fn find_lsp_server_from_env_path [name]
  (var path (vim.fn.exepath name))
  (when (= path "") (set path nil))
  (when (and path (has! :win32)
             (not (-> path
                      (vim.fs.basename)
                      (vim.fn.split "\\.")
                      (?. 2))))
    (set path (.. path ".cmd")))
  path)

(fn M.lsp_server_path [name]
  (or (find_lsp_server_from_mason name) (find_lsp_server_from_env_path name)))

(fn M.lsp_with_server [name f]
  (let [path (M.lsp_server_path name)]
    (when path (f path))))

(fn M.lsp_capabilities []
  (let [cmp (require :blink.cmp)
        opts {:textDocument {:semanticTokens {:multilineTokenSupport true}}
              :workspace {:fileOperations {:didRename true :willRename true}}}]
    (vim.tbl_deep_extend "force" (cmp.get_lsp_capabilities) opts)))

(fn lsp_format_on_save [client bufid]
  (local (has_conform _) (pcall require :conform))
  (when (and (not has_conform)
             (client:supports_method :textDocument/formatting))
    (let [grp (vim.api.nvim_create_augroup :lsp_format_on_save {})
          cb (partial vim.lsp.buf.format {:buffer bufid :timeout_ms 1000})]
      (vim.api.nvim_clear_autocmds {:group grp :buffer bufid})
      (autocmd! :BufWritePre {:group grp :buffer bufid :callback cb}))))

(fn lsp_codelens_refresh [client bufid]
  (when (client:supports_method :textDocument/codeLens)
    (let [grp (vim.api.nvim_create_augroup :lsp_codelens_refresh {})]
      (vim.api.nvim_clear_autocmds {:group grp :buffer bufid})
      (vim.lsp.codelens.refresh)
      (autocmd! [:BufEnter :InsertLeave]
                {:group grp :buffer bufid :callback vim.lsp.codelens.refresh}))))

(fn M.lsp_on_attach [client bufid]
  (tset vim.bo bufid :omnifunc nil)
  (local maps (require :core.maps))
  (maps.lsp bufid)
  (lsp_format_on_save client bufid)
  (lsp_codelens_refresh client bufid)
  nil)

(fn M.system_open [path]
  (vim.notify (.. "system_open path=" path) vim.log.levels.INFO)
  (local cmd (if (has! :win32) (.. "explorer.exe '" path "'")
                 (has! :macunix) (.. "open -g '" path "' &")
                 (.. "xdg-open '" path "' &")))
  (vim.fn.jobstart cmd {:detach true}))

(fn M.list_includes [a b]
  (vim.validate :a a :table)
  (vim.validate :b b :table)
  (when (< (length a) (length b)) (lua "return false"))
  (each [_ bv (ipairs b)]
    (var found false)
    (each [_ av (ipairs a)]
      (when (= av bv)
        (set found true)
        (lua "break")))
    (when (not found) (lua "return false")))
  true)

(fn M.get_buffer_count []
  (var result 0)
  (local bufs (vim.api.nvim_list_bufs))
  (each [_ bufid (ipairs bufs)]
    (when (. vim.bo bufid :buflisted)
      (set result (+ result 1))))
  result)

(fn M.get_selection_line_range []
  (let [a (vim.fn.line "v")
        b (vim.fn.line ".")]
    (if (<= a b) (values a b) (values b a))))

(fn M.get_last_selection_text []
  (vim.cmd "normal! gv\"xy")
  (vim.fn.trim (vim.fn.getreg "x")))

(fn M.get_current_selection_text []
  (vim.cmd "exe  \"normal \\<Esc>\"")
  (vim.cmd "normal! gv\"xy")
  (vim.fn.trim (vim.fn.getreg "x")))

(fn M.open_hover_window [text_or_lines title callback]
  (local lines (if (= :string (type text_or_lines))
                   (vim.fn.split text_or_lines "\n" true)
                   text_or_lines))
  (var max_cols 0)
  (each [_ l (ipairs lines)]
    (set max_cols (math.max max_cols (vim.api.nvim_strwidth l))))
  (local bufid (vim.api.nvim_create_buf false true))
  (vim.api.nvim_buf_set_lines bufid 0 -1 false lines)
  (local winid (vim.api.nvim_open_win bufid true
                                      {:relative :cursor
                                       :row 1
                                       :col 0
                                       :width max_cols
                                       :height (math.min 16 (length lines))
                                       :style :minimal
                                       :title title}))
  (M.disable_diagnostic bufid)
  (tset vim.bo bufid :readonly true)
  (tset vim.bo bufid :modifiable false)
  (tset vim.wo winid :wrap false)
  (when callback (callback bufid winid)))

(fn M.create_keymaps_for_goto_entries [pattern prev_key next_key tag bufid]
  (nvomap! prev_key (string.format "<Cmd>call search('%s', 'bw')<CR>" pattern)
           {:buffer bufid
            :silent true
            :desc (string.format "[goto_entries] Goto prev %s entry" tag)})
  (nvomap! next_key (string.format "<Cmd>call search('%s', 'w')<CR>" pattern)
           {:buffer bufid
            :silent true
            :desc (string.format "[goto_entries] Goto next %s entry" tag)}))

M
