(local lazypath (.. (vim.fn.stdpath :data) "/lazy/lazy.nvim"))
(when (not (vim.uv.fs_stat lazypath))
  (vim.fn.system ["git"
                  "clone"
                  "--filter=blob:none"
                  "https://github.com/folke/lazy.nvim.git"
                  "--branch=stable"
                  lazypath]))

(vim.opt.runtimepath:prepend lazypath)

(local lazy (require "lazy"))
(lazy.setup "lz.plugins"
            {:defaults {:lazy true}
             ;; :debug true
             :lockfile (.. (vim.fn.stdpath :config) "/lazy-lock.json")
             :git {:log ["--since=3 days ago"]
                   :timeout 120
                   :url_format "https://github.com/%s.git"}
             :ui {:size {:width 0.8 :height 0.8}
                  :border vim.o.winborder
                  :backdrop (or vim.g.zz.backdrop 100)}
             :performance {:reset_packpath true
                           :rtp {:disabled_plugins [:gzip
                                                    :matchit
                                                    :matchparen
                                                    :netrwPlugin
                                                    :tarPlugin
                                                    :tohtml
                                                    :tutor
                                                    :zipPlugin
                                                    :spellfile]}}})
