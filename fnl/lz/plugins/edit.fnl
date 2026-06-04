[{1 "lukas-reineke/indent-blankline.nvim"
  :main :ibl
  :opts {:indent {:char "▏"}}
  :keys [{1 "<Tab>i" 2 "<Cmd>IBLToggle<CR>" :mode [:n :v] :desc "[IBL] Toggle"}]}
 {1 "mbbill/undotree"
  :keys [{1 :<Leader>u 2 "<CMD>UndotreeToggle<CR>" :desc "[undotree] Toggle"}]}
 {1 "Wansmer/treesj"
  :opts {:use_default_keymaps false}
  :keys [{1 "<Leader>j" 2 "<Cmd>TSJToggle<CR>" :desc "[treesj] SplitJoin"}]}
 {1 "aaronik/treewalker.nvim"
  :opts {:highlight true :highlight_duration 300 :highlight_group :Visual}
  :keys (let [data [[:sh :Left]
                    [:sl :Right]
                    [:sk :Up]
                    [:sj :Down]
                    [:ssh :SwapLeft]
                    [:ssl :SwapRight]
                    [:ssk :SwapUp]
                    [:ssj :SwapDown]]]
          (icollect [_ [k v] (ipairs data)]
            {1 k
             2 (.. "<Cmd>Treewalker " v "<CR>")
             :mode (if (vim.startswith v :Swap) :n [:n :v])
             :desc (.. "[treewalker] " v)}))}
 {1 "folke/flash.nvim"
  :opts {:modes {:char {:enabled false}}}
  :keys (let [data [["<Leader>s" :jump [:n :x :o]]
                    ["<Leader>S" :treesitter [:n :x :o]]
                    [:r :remote :o]
                    [:R :treesitter_search [:x :o]]
                    [:<c-s> :toggle :c]]]
          (icollect [_ [k v m] (ipairs data)]
            {1 k 2 #((. (require :flash) v)) :mode m}))}]
