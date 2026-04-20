(import-macros {: call! : on!} :config.macros)

(fn add_custom_sources []
  (on! :User {:desc "[TS] perform actions after :TSUpdate"
              :pattern :TSUpdate
              :callback (fn []
                          (local parsers (require "nvim-treesitter.parsers"))
                          ;; crystal
                          (set parsers.crystal
                               {:install_info {:url "https://github.com/crystal-lang-tools/tree-sitter-crystal"
                                               :branch :main
                                               :generate false
                                               :generate_from_json false
                                               :queries "queries/nvim"}})
                          nil)}))

(fn install_langs []
  (call! :nvim-treesitter :install [:bash
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
                                    :commonlisp
                                    :scheme
                                    :clojure
                                    :crystal
                                    :go
                                    :gomod
                                    :java]))

[{1 "nvim-treesitter/nvim-treesitter-context" :cmd :TSContext :opts {}}
 {1 "nvim-treesitter/nvim-treesitter"
  :branch :main
  :build ":TSUpdate"
  :lazy false
  :config (fn []
            (add_custom_sources)
            (install_langs))}]
