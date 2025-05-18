{1 "saghen/blink.cmp"
 :lazy false
 :dependencies [{1 "rafamadriz/friendly-snippets"}]
 :opts {:appearance {:nerd_font_variant :mono}
        :signature {:enabled true}
        :sources {:default [:lsp :path :snippets :buffer]}
        :completion {:ghost_text {:enabled false}
                     :list {:selection {:preselect true :auto_insert false}}}
        :keymap {:preset :super-tab
                 :<M-j> [:select_next :fallback]
                 :<M-k> [:select_prev :fallback]
                 :<M-Space> [:show :show_documentation :hide_documentation]
                 :<C-c> [:hide :fallback]
                 :<C-u> [:scroll_documentation_up :fallback]
                 :<C-d> [:scroll_documentation_down :fallback]
                 :<C-k> [:fallback]}
        :cmdline {:completion {:menu {:auto_show true}
                               :list {:selection {:preselect true
                                                  :auto_insert false}}}
                  :keymap {:preset :none
                           :<Tab> [:accept]
                           :<M-j> [:select_next]
                           :<M-k> [:select_prev]
                           :<C-c> [:hide :fallback]}}}}
