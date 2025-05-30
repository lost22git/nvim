[{1 "echasnovski/mini.icons"
  :lazy false
  :config (fn []
            ((. (require :mini.icons) :setup))
            (MiniIcons.mock_nvim_web_devicons))}
 {1 "echasnovski/mini.cursorword" :lazy false :opts {}}
 {1 "echasnovski/mini.files"
  :lazy false
  :opts {:windows {:preview true}}
  :keys [{1 :<M-1> 2 #(MiniFiles.open) :desc "[mini.files] Open"}
         {1 :<M-2>
          2 #(MiniFiles.open (vim.api.nvim_buf_get_name 0) false)
          :desc "[mini.files] Open current directory"}]}
 {1 "echasnovski/mini.move" :lazy false :opts {}}
 {1 "echasnovski/mini.ai"
  :dependencies [{1 "echasnovski/mini.extra" :opts {}}]
  :lazy false
  :config (fn []
            (local {: setup : gen_spec} (require :mini.ai))
            (local {: gen_ai_spec} (require :mini.extra))
            (setup {:mappings {:around "a"
                               :inside "i"
                               :around_next "an"
                               :inside_next "in"
                               :around_last "al"
                               :inside_last "il"
                               :goto_left "["
                               :goto_right "]"}
                    :custom_textobjects {;; treesitter-textobject
                                         :F (gen_spec.treesitter {:a "@function.outer"
                                                                  :i "@function.inner"})
                                         :c (gen_spec.treesitter {:a "@class.outer"
                                                                  :i "@class.inner"})
                                         :o (gen_spec.treesitter {:a ["@conditional.outer"
                                                                      "@loop.outer"]
                                                                  :i ["@conditional.inner"
                                                                      "@loop.inner"]})
                                         ;; Mini.Extra
                                         :B (gen_ai_spec.buffer)
                                         :D (gen_ai_spec.diagnostic)
                                         :I (gen_ai_spec.indent)
                                         :L (gen_ai_spec.line)
                                         :N (gen_ai_spec.number)
                                         ;; custom
                                         ; C  comment_block
                                         }}))}
 {1 "echasnovski/mini.surround"
  :lazy false
  :opts {:mappings {:add :ms
                    :delete :md
                    :find :mf
                    :find_left :mF
                    :highlight :mh
                    :replace :mr
                    :update_n_lines :mn
                    :suffix_last :l
                    :suffix_next :n}}}
 {1 "echasnovski/mini.hipatterns"
  :lazy false
  :opts {:highlighters {:fixme {:pattern "%f[%w]()FIXME()%f[%W]"
                                :group "MiniHipatternsFixme"}
                        :hack {:pattern "%f[%w]()HACK()%f[%W]"
                               :group "MiniHipatternsHack"}
                        :todo {:pattern "%f[%w]()TODO()%f[%W]"
                               :group "MiniHipatternsTodo"}
                        :note {:pattern "%f[%w]()NOTE()%f[%W]"
                               :group "MiniHipatternsNote"}
                        :warn {:pattern "%f[%w]()WARN()%f[%W]"
                               :group "MiniHipatternsHack"}
                        :warning {:pattern "%f[%w]()WARNING()%f[%W]"
                                  :group "MiniHipatternsHack"}
                        :err {:pattern "%f[%w]()ERR()%f[%W]"
                              :group "MiniHipatternsFixme"}
                        :error {:pattern "%f[%w]()ERROR()%f[%W]"
                                :group "MiniHipatternsFixme"}}}}]
