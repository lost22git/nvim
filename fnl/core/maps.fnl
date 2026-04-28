(import-macros {: nmap! : imap! : cmap! : vmap! : nvmap! : nvomap! : tmap!}
               :config.macros)

(fn base []
  (nmap! "U" "<C-r>" {:desc "Redo"})
  (nmap! "<BS><BS>" "<Cmd>noh<CR>" {:desc "Cancel highlight"})
  (nmap! "=" "<C-a>" {:desc "Increment number"})
  (nmap! "-" "<C-x>" {:desc "Decrement number"})
  (nmap! "x" "\"_x" {:desc "Delete char to blackhold"})
  (nmap! "<Tab>b" "<Cmd>b #<CR>" {:desc "Buffer recent"})
  (nmap! "[<Tab>" "<Cmd>tabprevious<CR>" {:desc "Tab prev"})
  (nmap! "]<Tab>" "<Cmd>tabnext<CR>" {:desc "Tab next"})
  (nmap! "[<S-Tab>" "<Cmd>tabfirst<CR>" {:desc "Tab first"})
  (nmap! "]<S-Tab>" "<Cmd>tablast<CR>" {:desc "Tab last"})
  (imap! "<C-v>" "<Esc>\"+pa" {:desc "Paste from clipboard"})
  (vmap! "<" "<gv" {:desc "Indent left"})
  (vmap! ">" ">gv" {:desc "Indent right"})
  (vmap! "<C-c>" "\"+y" {:desc "Yank to clipboard"})
  (nvmap! "`" "q" {:desc "The old `q`"})
  (nvmap! "q" "<Nop>")
  (nvmap! "qq" "<Cmd>q<CR>" {:desc "Quit Neovim"})
  (nvmap! "Q" "<Cmd>q!<CR>" {:desc "Quit Neovim forcely"})
  (nvmap! "<C-s>" "<Cmd>w<CR>" {:desc "Save buffer"})
  (nvmap! "<C-v>" "\"+p" {:desc "Paste from clipboard"})
  (nvmap! "<C-x>" "<Cmd>bd<CR>" {:desc "Delete buffer"})
  (nvmap! "<C-h>" "<C-w>h" {:desc "Focus left window"})
  (nvmap! "<C-k>" "<C-w>k" {:desc "Focus up window"})
  (nvmap! "<C-j>" "<C-w>j" {:desc "Focus down window"})
  (nvmap! "<C-l>" "<C-w>l" {:desc "Focus right window"})
  (nvmap! "<C-M-h>" "<C-w><" {:desc "Resize window"})
  (nvmap! "<C-M-l>" "<C-w>>" {:desc "Resize window"})
  (nvmap! "<C-M-j>" "<C-w>+" {:desc "Resize window"})
  (nvmap! "<C-M-k>" "<C-w>-" {:desc "Resize window"})
  (nvmap! "<C-M-g>" "<C-w>=" {:desc "Resize window"})
  (nvomap! "<C-a>" "gg<S-v>G" {:desc "Select all"})
  (nvomap! "H" "^" {:desc "Goto line head"})
  (nvomap! "L" "$" {:desc "Goto line tail"})
  (nvomap! "mm" "%" {:desc "The old `%`"})
  (tmap! "<Esc>" "<C-\\><C-n>" {:desc "Escape terminal mode"}))

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

  (nvmap! "<Leader>m" create_messages_buf {:desc "Messages"}))

(base)
(messages)

(local M {})

(fn M.lsp [bufid]
  (local opts {:buffer bufid})
  (nmap! "gd" vim.lsp.buf.definition opts)
  (nmap! "<tab>d" #(vim.diagnostic.enable (not (vim.diagnostic.is_enabled)))
         opts)
  (nmap! "[D"
         (partial vim.diagnostic.jump
                  {:count -1 :severity vim.diagnostic.severity.ERROR})
         opts)
  (nmap! "]D"
         (partial vim.diagnostic.jump
                  {:count 1 :severity vim.diagnostic.severity.ERROR})
         opts))

(fn M.gitsigns [bufid]
  (local opts {:buffer bufid})
  (nmap! "[h" "<Cmd>Gitsigns prev_hunk<CR>" opts)
  (nmap! "]h" "<Cmd>Gitsigns next_hunk<CR>" opts)
  (nmap! "<Tab>h" "<Cmd>Gitsigns preview_hunk<CR>" opts)
  (nmap! "<Leader>hb" "<Cmd>Gitsigns blame<CR>" opts)
  (nmap! "<Leader>hd" "<Cmd>Gitsigns diffthis<CR>" opts)
  (nmap! "<Leader>hl" "<Cmd>Gitsigns blame_line<CR>" opts)
  (nmap! "<Leader>hr" "<Cmd>Gitsigns reset_hunk<CR>" opts)
  (nmap! "<Leader>hs" "<Cmd>Gitsigns stage_hunk<CR>" opts)
  (nmap! "<Leader>hv" "<Cmd>Gitsigns select_hunk<CR>" opts))

M
