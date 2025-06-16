(import-macros {: nmap! : imap! : cmap! : vmap! : nvmap! : nvomap!}
               :config.macros)

(fn base []
  (nmap! "U" "<C-r>" {:desc "[base] Redo"})
  (nmap! "<BS><BS>" "<Cmd>noh<CR>" {:desc "[base] Cancel highlight"})
  (nmap! "=" "<C-a>" {:desc "[base] Increment number"})
  (nmap! "-" "<C-x>" {:desc "[base] Decrement number"})
  (nmap! "x" "\"_x" {:desc "[base] Delete char to blackhold"})
  (nmap! "<Tab>b" "<Cmd>b #<CR>" {:desc "[base] Buffer recent"})
  (nmap! "[<Tab>" "<Cmd>tabprevious<CR>" {:desc "[base] Tab prev"})
  (nmap! "]<Tab>" "<Cmd>tabnext<CR>" {:desc "[base] Tab next"})
  (nmap! "[<S-Tab>" "<Cmd>tabfirst<CR>" {:desc "[base] Tab first"})
  (nmap! "]<S-Tab>" "<Cmd>tablast<CR>" {:desc "[base] Tab last"})
  (imap! "<C-v>" "<Esc>\"+pa" {:desc "[base] Paste from clipboard"})
  (vmap! "<" "<gv" {:desc "[base] Indent left"})
  (vmap! ">" ">gv" {:desc "[base] Indent right"})
  (vmap! "<C-c>" "\"+y" {:desc "[base] Yank to clipboard"})
  (nvmap! "`" "q" {:desc "[base] The old `q`"})
  (nvmap! "q" "<Nop>")
  (nvmap! "qq" "<Cmd>q<CR>" {:desc "[base] Quit Neovim"})
  (nvmap! "Q" "<Cmd>q!<CR>" {:desc "[base] Quit Neovim forcely"})
  (nvmap! "<C-s>" "<Cmd>w<CR>" {:desc "[base] Save buffer"})
  (nvmap! "<C-v>" "\"+p" {:desc "[base] Paste from clipboard"})
  (nvmap! "<C-x>" "<Cmd>bd<CR>" {:desc "[base] Delete buffer"})
  (nvmap! "<C-h>" "<C-w>h" {:desc "[base] Focus left window"})
  (nvmap! "<C-k>" "<C-w>k" {:desc "[base] Focus up window"})
  (nvmap! "<C-j>" "<C-w>j" {:desc "[base] Focus down window"})
  (nvmap! "<C-l>" "<C-w>l" {:desc "[base] Focus right window"})
  (nvmap! "<C-M-h>" "<C-w><" {:desc "[base] Resize window"})
  (nvmap! "<C-M-l>" "<C-w>>" {:desc "[base] Resize window"})
  (nvmap! "<C-M-j>" "<C-w>+" {:desc "[base] Resize window"})
  (nvmap! "<C-M-k>" "<C-w>-" {:desc "[base] Resize window"})
  (nvmap! "<C-M-g>" "<C-w>=" {:desc "[base] Resize window"})
  (nvomap! "<C-a>" "gg<S-v>G" {:desc "[base] Select all"})
  (nvomap! "<Leader>J" "J" {:desc "[base] The old `J`"})
  (nvomap! "J" "}" {:desc "[base] Goto next blank line"})
  (nvomap! "K" "{" {:desc "[base] Goto prev blank line"})
  (nvomap! "H" "^" {:desc "[base] Goto line head"})
  (nvomap! "L" "$" {:desc "[base] Goto line tail"})
  (nvomap! "mm" "%" {:desc "[base] The old `%`"}))

(fn readline []
  (imap! "<C-a>" "<C-o>^" {:desc "[readline] Goto line head"})
  (imap! "<C-b>" "<Left>" {:desc "[readline] Goto prev char"})
  (imap! "<C-d>" "<Del>" {:desc "[readline] Delete next char"})
  (imap! "<C-e>" "<C-o>$" {:desc "[readline] Goto line tail"})
  (imap! "<C-f>" "<Right>" {:desc "[readline] Goto next char"})
  (imap! "<C-k>" "<C-o>d$" {:desc "[readline] Delete to line tail"})
  (imap! "<C-u>" "<C-o>d^" {:desc "[readline] Delete to line head"})
  (cmap! "<C-a>" "<Home>" {:silent false :desc "[readline] Goto line begin"})
  (cmap! "<C-b>" "<Left>" {:silent false :desc "[readline] Goto prev char"})
  (cmap! "<C-d>" "<Del>" {:silent false :desc "[readline] Delete next char"})
  (cmap! "<C-f>" "<Right>" {:silent false :desc "[readline] Goto next char"}))

(fn highlight_visual []
  (local nsid (vim.api.nvim_create_namespace :zz_highlight_visual))

  (fn do_highlight_visual []
    (vim.api.nvim_buf_clear_namespace 0 nsid 0 -1)
    (local mode (vim.fn.mode))
    ;; N MODE
    (when (= :n mode) (lua "return"))
    ;; V MODES
    (local [begin finish]
           (case mode
             ;; V-LINE MODE
             :V
             (let [lc (vim.fn.line ".")
                   lp (vim.fn.line "v")]
               (if (> lc lp)
                   [[(- lp 1) 0] [(- lc 1) vim.v.maxcol]]
                   [[(- lc 1) 0] [(- lp 1) vim.v.maxcol]]))
             ;; V MODE OR V-BLOCK MODE
             _
             (let [pc (vim.fn.getpos ".")
                   pp (vim.fn.getpos "v")
                   pcl (. pc 2)
                   pcc (. pc 3)
                   ppl (. pp 2)
                   ppc (. pp 3)]
               (if (or (> pcl ppl) (and (= pcl ppl) (> pcc ppc)))
                   [[(- ppl 1) (- ppc 1)] [(- pcl 1) pcc]]
                   [[(- pcl 1) (- pcc 1)] [(- ppl 1) ppc]]))))
    (vim.hl.range 0 nsid :Visual begin finish)
    (vim.cmd "exe \"normal \\<Esc>\""))

  (nvmap! "<Leader>v" do_highlight_visual {:desc "[base] Highlight Visual"}))

(fn messages []
  (fn create_messages_buf []
    (local bufid (vim.api.nvim_create_buf false true))
    (tset vim.bo bufid :filetype "messages")
    (local text (vim.split (vim.fn.execute "messages" "silent") "\n"))
    (vim.api.nvim_buf_set_text bufid 0 0 0 0 text)
    (vim.cmd (.. "horizontal sbuffer " bufid))
    (set vim.opt_local.wrap true)
    (set vim.bo.buflisted false)
    (set vim.bo.bufhidden "wipe"))

  (nvmap! "<Leader>m" create_messages_buf {:desc "[base] Messages"}))

(base)
(readline)
(highlight_visual)
(messages)

(local M {})

(fn M.lsp [bufid]
  (local opts {:buffer bufid})
  (nmap! "gd" vim.lsp.buf.definition opts)
  (nmap! "gk" vim.lsp.buf.hover opts)
  (nmap! "gs" vim.lsp.buf.document_symbol opts)
  (nmap! "gS" vim.lsp.buf.workspace_symbol opts)
  (nmap! "gt" vim.lsp.buf.type_definition opts)
  (nmap! "[D" (partial vim.diagnostic.jump
                       {:count -1
                        :float true
                        :severity vim.diagnostic.severity.ERROR})
         opts)
  (nmap! "]D" (partial vim.diagnostic.jump
                       {:count 1
                        :float true
                        :severity vim.diagnostic.severity.ERROR})
         opts))

(fn M.gitsigns [bufid]
  (local opts {:buffer bufid})
  (nmap! "[h" "<Cmd>Gitsigns prev_hunk<CR>" opts)
  (nmap! "]h" "<Cmd>Gitsigns next_hunk<CR>" opts)
  (nmap! "<Tab>h" "<Cmd>Gitsigns preview_hunk<CR>" opts)
  (nmap! "<Leader>hr" "<Cmd>Gitsigns reset_hunk<CR>" opts)
  (nmap! "<Leader>hs" "<Cmd>Gitsigns stage_hunk<CR>" opts)
  (nmap! "<Leader>hv" "<Cmd>Gitsigns select_hunk<CR>" opts))

M
