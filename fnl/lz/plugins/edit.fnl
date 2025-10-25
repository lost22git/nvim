[{1 "lost22git/highlight-visual.nvim" :lazy false :opts {}}
 {1 "TheBlob42/houdini.nvim"
  :event [:InsertEnter :CmdLineEnter :TermEnter]
  :opts {:timeout 250 :escape_sequences {:v false :V false :c :<BS><BS><Esc>}}}
 {1 "Wansmer/treesj"
  :dependencies ["nvim-treesitter/nvim-treesitter"]
  :opts {:use_default_keymaps false}
  :keys [{1 "<Leader>j" 2 "<Cmd>TSJToggle<CR>" :desc "[treesj] Split/Join"}]}
 {1 "aaronik/treewalker.nvim"
  :opts {:highlight true :highlight_duration 300 :highlight_group :Visual}
  :keys (let [data [[:th :Left]
                    [:tl :Right]
                    [:tk :Up]
                    [:tj :Down]
                    [:tsh :SwapLeft]
                    [:tsl :SwapRight]
                    [:tsk :SwapUp]
                    [:tsj :SwapDown]]]
          (icollect [_ [k v] (ipairs data)]
            {1 k
             2 (.. "<Cmd>Treewalker " v "<CR>")
             :mode (if (vim.startswith v :Swap) :n [:n :v])
             :desc (.. "[treewalker] " v)}))}
 {1 "julienvincent/nvim-paredit"
  :event :VeryLazy
  :opts {:filetypes [:clojure :fennel :janet :lisp]
         :use_default_keys false
         :keys (vim.tbl_extend :error ;;
                               (collect [_ [k v] (ipairs [[:du :raise_form]
                                                          [:dU :raise_element]
                                                          [">)"
                                                           :slurp_forwards]
                                                          [">("
                                                           :barf_backwards]
                                                          ["<)" :barf_forwards]
                                                          ["<("
                                                           :slurp_backwards]
                                                          [:>D
                                                           :drag_pair_forwards]
                                                          [:<D
                                                           :drag_pair_backwards]
                                                          [:>E
                                                           :drag_element_forwards]
                                                          [:<E
                                                           :drag_element_backwards]
                                                          [:>F
                                                           :drag_form_forwards]
                                                          [:<F
                                                           :drag_form_backwards]])]
                                 (values k
                                         [#((. (require :nvim-paredit) :api v))
                                          v])) ;;
                               (collect [_ [k v] (ipairs [[:<A :inner_start]
                                                          [:>A :inner_end]])]
                                 (values k
                                         [#(let [par (require :nvim-paredit)]
                                             (par.cursor.place_cursor (par.wrap.wrap_enclosing_form_under_cursor "("
                                                                                                                 ")")
                                                                      {:placement v
                                                                       :mode :insert}))
                                          (.. "Wrap form " v)])))}}
 {1 "folke/flash.nvim"
  :opts {:modes {:char {:enabled false}}}
  :keys (let [data [["<Leader>s" :jump [:n :x :o]]
                    ["<Leader>S" :treesitter [:n :x :o]]
                    [:r :remote :o]
                    [:R :treesitter_search [:x :o]]
                    [:<c-s> :toggle :c]]]
          (icollect [_ [k v m] (ipairs data)]
            {1 k 2 #((. (require :flash) v)) :mode m}))}
 {1 "MagicDuck/grug-far.nvim" :cmd [:GrugFar :GrugFarWithin] :opts {}}
 {1 "andrewferrier/debugprint.nvim"
  :cmd :DeleteDebugPrints
  :keys [:g?]
  :opts {}}]
