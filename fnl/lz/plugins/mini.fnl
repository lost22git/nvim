(import-macros {: call!} :config.macros)

[{1 "nvim-mini/mini.icons"
  :lazy false
  :config (fn []
            (call! :mini.icons :setup)
            (MiniIcons.mock_nvim_web_devicons))}
 {1 "nvim-mini/mini.cursorword" :lazy false :opts {}}
 {1 "nvim-mini/mini.move" :lazy false :opts {}}
 {1 "nvim-mini/mini.ai"
  :dependencies [{1 "nvim-mini/mini.extra" :opts {}}]
  :lazy false
  :config (fn []
            (local {: setup : gen_spec} (require :mini.ai))
            (local {: gen_ai_spec} (require :mini.extra))
            (setup {:mappings {:around "a"
                               :inside "i"
                               :around_next "a]"
                               :inside_next "i]"
                               :around_last "a["
                               :inside_last "i["
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
                                         :N (gen_ai_spec.number)}}))}
 {1 "nvim-mini/mini.surround" :lazy false :opts {:mappings {:add :ss}}}
 {1 "nvim-mini/mini.hues"
  :enabled false
  :lazy false
  :init #(vim.cmd.colorscheme :minisummer)}
 {1 "nvim-mini/mini.bufremove" :lazy false :opts {}}
 {1 "nvim-mini/mini.files"
  :lazy false
  :opts {:windows {:preview true}}
  :keys [{1 :<M-1> 2 #(MiniFiles.open) :desc "[mini.files] Open"}
         {1 :<M-2>
          2 #(MiniFiles.open (vim.api.nvim_buf_get_name 0) false)
          :desc "[mini.files] Open current directory"}]}]
