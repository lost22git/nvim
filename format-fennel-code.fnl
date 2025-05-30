;; [nfnl-macro]

(print "Formatting fennel code ...")
(case (os.execute "fd -u -t f -g '*.fnl' | xargs fnlfmt --fix")
  (true _ _) (print "Done")
  (false _ code) (print "Error: " code))
