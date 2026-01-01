;; Add filetypes
(vim.filetype.add {:extension {:art :arturo
                               :bb :clojure
                               :c3 :c3
                               :cljd :clojure
                               :cy :cyber
                               :fnlm :fennel
                               :flix :flix
                               :http :http
                               :kk :koka
                               :lfe :lfe
                               :lobster :lobster
                               :lpy :clojure
                               :n :nature
                               :postcss :postcss
                               :v :v
                               :vsh :v}})

;; Add commentstring
(vim.cmd "
  au FileType arturo setlocal commentstring=;\\ %s
  au FileType basilisp setlocal commentstring=;\\ %s
  au FileType c3 setlocal commentstring=//\\ %s
  au FileType crystal setlocal commentstring=#\\ %s
  au FileType cyber setlocal commentstring=--\\ %s
  au FileType fennel setlocal commentstring=;\\ %s
  au FileType flix setlocal commentstring=//\\ %s
  au FileType http setlocal commentstring=#\\ %s
  au FileType inko setlocal commentstring=#\\ %s
  au FileType janet setlocal commentstring=#\\ %s
  au FileType json setlocal commentstring=//\\ %s
  au FileType just setlocal commentstring=#\\ %s
  au FileType koka setlocal commentstring=//\\ %s
  au FileType lfe setlocal commentstring=;\\ %s
  au FileType lobster setlocal commentstring=//\\ %s
  au FileType nature setlocal commentstring=//\\ %s
")
