(fn use_helix_source []
  (local rtp vim.env.HELIX_RUNTIMEPATH)
  (when (and rtp (vim.fn.exists rtp))
    ;; queries
    (vim.opt.runtimepath:append rtp)
    ;; parsers
    (local parser_source (.. rtp "/grammars/sources/"))
    (local parser_config ((. (require :nvim-treesitter.parsers)
                             :get_parser_configs)))
    (set parser_config.koka
         {:filetype :koka
          :install_info {:url (.. parser_source :koka)
                         :files ["src/parser.c" "src/scanner.c"]}})
    (set parser_config.nu
         {:filetype :nu
          :install_info {:url (.. parser_source :nu) :files ["src/parser.c"]}})))

(fn use_custom_source []
  (local parser_config ((. (require :nvim-treesitter.parsers)
                           :get_parser_configs)))
  (set parser_config.crystal
       {:filetype :crystal
        :install_info {:url "https://github.com/crystal-lang-tools/tree-sitter-crystal"
                       :branch :main
                       :files ["src/parser.c" "src/scanner.c"]}}))

(fn define_fold_module []
  ((. (require :nvim-treesitter) :define_modules) {:fold {:attach #(do
                                                                     (set vim.opt_local.foldmethod
                                                                          :expr)
                                                                     (set vim.opt_local.foldexpr
                                                                          "v:lua.vim.treesitter.foldexpr()"))
                                                          :detach #(do
                                                                     (set vim.opt_local.foldmethod
                                                                          vim.go.foldmethod)
                                                                     (set vim.opt_local.foldexpr
                                                                          vim.go.foldexpr))
                                                          :is_supported (fn []
                                                                          true)}}))

[{1 "nvim-treesitter/nvim-treesitter"
  :build #(let [{: update} (require :nvim-treesitter.install)
                ts_update (update {:with_sync true})]
            (ts_update))
  :dependencies ["nvim-treesitter/nvim-treesitter-textobjects"]
  :event [:BufReadPost :BufNewFile]
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
         :fold {:enable true}
         :ensure_installed [:bash
                            :lua
                            :regex
                            :vim
                            :vimdoc
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
                            :markdown
                            :markdown_inline
                            ;;
                            :css
                            :html
                            :javascript
                            :typescript
                            ;;
                            :clojure
                            :crystal
                            :gleam
                            :go
                            :gomod
                            :java
                            :nim
                            :rust
                            :zig]}
  :config (fn [_ opts]
            (use_helix_source)
            (use_custom_source)
            (define_fold_module)
            ((. (require :nvim-treesitter.configs) :setup) opts))}
 {1 "nvim-treesitter/nvim-treesitter-context" :cmd :TSContextEnable :opts {}}]
