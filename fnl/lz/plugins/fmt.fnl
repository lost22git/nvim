{1 "stevearc/conform.nvim"
 :event :BufWritePre
 :opts {:default_format_opts {:lsp_format :fallback}
        :format_on_save {:lsp_format :fallback :timeout_ms 5000}
        ;; see :help conform-formatters
        :formatters_by_ft {:clojure [:cljfmt]
                           :crystal [:crystal]
                           :css [:prettier]
                           :dart [:dart_format]
                           :elixir [:mix]
                           :fennel [:fnlfmt]
                           :gleam [:gleam]
                           :go [:gofmt :goimports]
                           :http [:kulala-fmt]
                           :html [:prettier]
                           :inko [:inko]
                           :janet [:janet-format]
                           :java [:google-java-format]
                           :javascript [:deno_fmt]
                           :jsx [:prettier]
                           :json [:jq :prettier]
                           :just [:just]
                           :kotlin [:ktfmt]
                           :lisp [:cljfmt]
                           :lua [:stylua]
                           :nim [:nph]
                           :ocaml [:ocamlformat]
                           :python [:ruff_format]
                           :racket [:myracketfmt]
                           :roc [:roc]
                           :scheme [:cljfmt]
                           :sh [:shfmt]
                           :swift [:swift]
                           :toml [:taplo]
                           :typescript [:deno_fmt]
                           :v [:v]
                           :xml [:prettier]
                           :zig [:zigfmt]}
        :formatters {:myracketfmt {:command "raco"
                                   :args ["fmt" "--limit" "50"]}}}}
