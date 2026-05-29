[{1 "lost22git/nvim-paredit"
  :branch :add-racket-lang
  :lazy false
  :opts {:use_default_keys false
         :keys (vim.tbl_extend :error
                               (let [data [[:du :raise_form]
                                           [:dU :raise_element]
                                           [">)" :slurp_forwards]
                                           [">(" :barf_backwards]
                                           ["<)" :barf_forwards]
                                           ["<(" :slurp_backwards]
                                           [:>D :drag_pair_forwards]
                                           [:<D :drag_pair_backwards]
                                           [:>E :drag_element_forwards]
                                           [:<E :drag_element_backwards]
                                           [:>F :drag_form_forwards]
                                           [:<F :drag_form_backwards]
                                           [:E :move_to_next_element_tail]
                                           [:W :move_to_next_element_head]
                                           [:B :move_to_prev_element_head]
                                           [:gE :move_to_prev_element_tail]
                                           ["(" :move_to_parent_form_start]
                                           [")" :move_to_parent_form_end]
                                           [:T :move_to_top_level_form_head]]]
                                 (collect [_ [k v] (ipairs data)]
                                   (values k
                                           [#((. (require :nvim-paredit) :api v))
                                            (.. "[paredit] " v)])))
                               (let [data [[:<A :inner_start] [:>A :inner_end]]]
                                 (collect [_ [k v] (ipairs data)]
                                   (values k
                                           [#(let [par (require :nvim-paredit)]
                                               (-> (par.wrap.wrap_enclosing_form_under_cursor "("
                                                                                              ")")
                                                   (par.cursor.place_cursor {:placement v
                                                                             :mode :insert})))
                                            (.. "[paredit] Wrap form " v)]))))}}]
