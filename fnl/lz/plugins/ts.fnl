(import-macros {: call!} :config.macros)

(fn use_helix_source []
  (local rtp vim.env.HELIX_RUNTIMEPATH)
  (when (and rtp (vim.fn.exists rtp))
    ;; queries
    (vim.opt.runtimepath:append rtp)
    ;; parsers
    (local parser_source (.. rtp "/grammars/sources/"))
    (local parser_config (call! :nvim-treesitter.parsers :get_parser_configs))
    (set parser_config.koka
         {:filetype :koka
          :install_info {:url (.. parser_source :koka)
                         :files ["src/parser.c" "src/scanner.c"]}})
    (set parser_config.nu
         {:filetype :nu
          :install_info {:url (.. parser_source :nu) :files ["src/parser.c"]}})))

(fn use_custom_source []
  (local parser_config (call! :nvim-treesitter.parsers :get_parser_configs))
  ;; crystal
  (set parser_config.crystal
       {:filetype :crystal
        :install_info {:url "https://github.com/crystal-lang-tools/tree-sitter-crystal"
                       :branch :main
                       :files ["src/parser.c" "src/scanner.c"]}}))

[{1 "nvim-treesitter/nvim-treesitter-context"
  :dependencies ["nvim-treesitter/nvim-treesitter"]
  :cmd :TSContextEnable
  :opts {}}
 {1 "nvim-treesitter/nvim-treesitter"
  :build #(let [{: update} (require :nvim-treesitter.install)
                ts_update (update {:with_sync true})]
            (ts_update))
  :dependencies ["nvim-treesitter/nvim-treesitter-textobjects"]
  :event :VeryLazy
  :opts {:sync_install false
         :auto_install false
         :highlight {:enable true
                     :additional_vim_regex_highlighting [:ruby]
                     :disable {}}
         :indent {:enable true :disable [:ruby]}
         :incremental_selection {:enable true
                                 :disable [:vim]
                                 :keymaps {:init_selection :<CR>
                                           :node_incremental :<CR>
                                           :node_decremental :<BS>}}
         :autotag {:enable true}
         :ensure_installed [:bash
                            :lua
                            :fennel
                            :regex
                            :vim
                            :vimdoc
                            ;;
                            :markdown
                            :markdown_inline
                            ;;
                            :dockerfile
                            :http
                            :hurl
                            :just
                            :sql
                            ;;
                            :json
                            :toml
                            :xml
                            :yaml
                            ;;
                            :css
                            :html
                            :javascript
                            :typescript
                            ;;
                            :clojure
                            :crystal
                            :go
                            :gomod
                            :java]}
  :config (fn [_ opts]
            (use_helix_source)
            (use_custom_source)
            (call! :nvim-treesitter.configs :setup opts))}]
