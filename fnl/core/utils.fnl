(import-macros {: has! : autocmd! : nvomap!} :config.macros)

(local M {})

(fn M.on_gui []
  (or vim.g.neovide vim.g.fvim_loaded vim.g.vscode))

(fn M.on_v_modes []
  (let [v_block_mode (vim.api.nvim_replace_termcodes :<C-V> true true true)
        v_modes [:v :V v_block_mode]]
    (vim.list_contains v_modes (vim.fn.mode))))

(fn M.disable_diagnostic [bufid]
  (when (vim.diagnostic.is_enabled {:bufnr bufid})
    (pcall vim.diagnostic.enable false {:bufnr bufid})))

(fn M.get_flutter_path []
  (let [path (vim.fn.exepath "flutter")]
    (if (has! :win32) (.. path ".bat") path)))

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
  (case (M.lsp_server_path name)
    path (f path)))

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

(fn M.create_keymaps_for_goto_entry [pattern prev_key next_key tag bufid]
  (nvomap! prev_key (string.format "<Cmd>call search('%s', 'bw')<CR>" pattern)
           {:buffer bufid
            :silent true
            :desc (string.format "[goto_entry] Goto prev %s entry" tag)})
  (nvomap! next_key (string.format "<Cmd>call search('%s', 'w')<CR>" pattern)
           {:buffer bufid
            :silent true
            :desc (string.format "[goto_entry] Goto next %s entry" tag)}))

M
