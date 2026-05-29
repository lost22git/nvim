(local completion_list_opts {:selection {:preselect true :auto_insert false}})
(local common_keymaps {:<Tab> [:accept :fallback]
                       :<M-j> [:select_next]
                       :<M-k> [:select_prev]
                       :<C-c> [:hide :fallback]})

{1 "saghen/blink.cmp"
 :version "1.*"
 :event [:InsertEnter :CmdlineEnter]
 :dependencies [{1 "rafamadriz/friendly-snippets"}
                {1 "mikavilpas/blink-ripgrep.nvim"}]
 :init (fn []
         (set vim.opt.autocomplete false))
 :opts {:appearance {:nerd_font_variant "mono"}
        :signature {:enabled true}
        :fuzzy {:implementation "prefer_rust_with_warning"}
        :sources {:default [:lsp :path :snippets :buffer :ripgrep]
                  :providers {:ripgrep {:module :blink-ripgrep
                                        :name :Ripgrep
                                        :score_offset -10
                                        :opts {}}}}
        :completion {:list completion_list_opts}
        :keymap (vim.tbl_deep_extend :force common_keymaps
                                     {:preset :super-tab
                                      :<M-Space> [:show
                                                  :show_documentation
                                                  :hide_documentation]
                                      :<C-u> [:scroll_documentation_up
                                              :fallback]
                                      :<C-d> [:scroll_documentation_down
                                              :fallback]
                                      :<C-k> [:fallback]})
        :cmdline {:completion {:list completion_list_opts
                               :menu {:auto_show true}}
                  :keymap (vim.tbl_deep_extend :force common_keymaps
                                               {:preset :none})}}
 :opts_extend ["sources.default"]}
