-- [nfnl] fnl/core/maps.fnl
local function base()
  vim.keymap.set("n", "U", "<C-r>", {desc = "Redo"})
  vim.keymap.set("n", "<BS><BS>", "<Cmd>noh<CR>", {desc = "Cancel highlight"})
  vim.keymap.set("n", "=", "<C-a>", {desc = "Increment number"})
  vim.keymap.set("n", "-", "<C-x>", {desc = "Decrement number"})
  vim.keymap.set("n", "x", "\"_x", {desc = "Delete char to blackhold"})
  vim.keymap.set("n", "<Tab>b", "<Cmd>b #<CR>", {desc = "Buffer recent"})
  vim.keymap.set("n", "[<Tab>", "<Cmd>tabprevious<CR>", {desc = "Tab prev"})
  vim.keymap.set("n", "]<Tab>", "<Cmd>tabnext<CR>", {desc = "Tab next"})
  vim.keymap.set("n", "[<S-Tab>", "<Cmd>tabfirst<CR>", {desc = "Tab first"})
  vim.keymap.set("n", "]<S-Tab>", "<Cmd>tablast<CR>", {desc = "Tab last"})
  vim.keymap.set("i", "<C-v>", "<Esc>\"+pa", {desc = "Paste from clipboard"})
  vim.keymap.set("v", "<", "<gv", {desc = "Indent left"})
  vim.keymap.set("v", ">", ">gv", {desc = "Indent right"})
  vim.keymap.set("v", "<C-c>", "\"+y", {desc = "Yank to clipboard"})
  vim.keymap.set({"n", "v"}, "`", "q", {desc = "The old `q`"})
  vim.keymap.set({"n", "v"}, "q", "<Nop>")
  vim.keymap.set({"n", "v"}, "qq", "<Cmd>q<CR>", {desc = "Quit Neovim"})
  vim.keymap.set({"n", "v"}, "Q", "<Cmd>q!<CR>", {desc = "Quit Neovim forcely"})
  vim.keymap.set({"n", "v"}, "<C-s>", "<Cmd>w<CR>", {desc = "Save buffer"})
  vim.keymap.set({"n", "v"}, "<C-v>", "\"+p", {desc = "Paste from clipboard"})
  vim.keymap.set({"n", "v"}, "<C-x>", "<Cmd>bd<CR>", {desc = "Delete buffer"})
  vim.keymap.set({"n", "v"}, "<C-h>", "<C-w>h", {desc = "Focus left window"})
  vim.keymap.set({"n", "v"}, "<C-k>", "<C-w>k", {desc = "Focus up window"})
  vim.keymap.set({"n", "v"}, "<C-j>", "<C-w>j", {desc = "Focus down window"})
  vim.keymap.set({"n", "v"}, "<C-l>", "<C-w>l", {desc = "Focus right window"})
  vim.keymap.set({"n", "v"}, "<C-M-h>", "<C-w><", {desc = "Resize window"})
  vim.keymap.set({"n", "v"}, "<C-M-l>", "<C-w>>", {desc = "Resize window"})
  vim.keymap.set({"n", "v"}, "<C-M-j>", "<C-w>+", {desc = "Resize window"})
  vim.keymap.set({"n", "v"}, "<C-M-k>", "<C-w>-", {desc = "Resize window"})
  vim.keymap.set({"n", "v"}, "<C-M-g>", "<C-w>=", {desc = "Resize window"})
  vim.keymap.set({"n", "v", "o"}, "<C-a>", "gg<S-v>G", {desc = "Select all"})
  vim.keymap.set({"n", "v", "o"}, "<Leader>J", "J", {desc = "The old `J`"})
  vim.keymap.set({"n", "v", "o"}, "J", "}", {desc = "Goto next blank line"})
  vim.keymap.set({"n", "v", "o"}, "K", "{", {desc = "Goto prev blank line"})
  vim.keymap.set({"n", "v", "o"}, "H", "^", {desc = "Goto line head"})
  vim.keymap.set({"n", "v", "o"}, "L", "$", {desc = "Goto line tail"})
  return vim.keymap.set({"n", "v", "o"}, "mm", "%", {desc = "The old `%`"})
end
local function readline()
  vim.keymap.set("i", "<C-a>", "<C-o>^", {desc = "[readline] Goto line head"})
  vim.keymap.set("i", "<C-b>", "<Left>", {desc = "[readline] Goto prev char"})
  vim.keymap.set("i", "<C-d>", "<Del>", {desc = "[readline] Delete next char"})
  vim.keymap.set("i", "<C-e>", "<C-o>$", {desc = "[readline] Goto line tail"})
  vim.keymap.set("i", "<C-f>", "<Right>", {desc = "[readline] Goto next char"})
  vim.keymap.set("i", "<C-k>", "<C-o>d$", {desc = "[readline] Delete to line tail"})
  vim.keymap.set("i", "<C-u>", "<C-o>d^", {desc = "[readline] Delete to line head"})
  vim.keymap.set("c", "<C-a>", "<Home>", {desc = "[readline] Goto line begin", silent = false})
  vim.keymap.set("c", "<C-b>", "<Left>", {desc = "[readline] Goto prev char", silent = false})
  vim.keymap.set("c", "<C-d>", "<Del>", {desc = "[readline] Delete next char", silent = false})
  return vim.keymap.set("c", "<C-f>", "<Right>", {desc = "[readline] Goto next char", silent = false})
end
local function messages()
  local function create_messages_buf()
    local bufid = vim.api.nvim_create_buf(false, true)
    vim.bo[bufid]["filetype"] = "messages"
    local text = vim.split(vim.fn.execute("messages", "silent"), "\n")
    vim.api.nvim_buf_set_text(bufid, 0, 0, 0, 0, text)
    vim.cmd(("horizontal sbuffer " .. bufid))
    vim.opt_local.wrap = true
    vim.bo.buflisted = false
    vim.bo.bufhidden = "wipe"
    return nil
  end
  return vim.keymap.set({"n", "v"}, "<Leader>m", create_messages_buf, {desc = "Messages"})
end
base()
readline()
messages()
local M = {}
M.lsp = function(bufid)
  local opts = {buffer = bufid}
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gk", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol, opts)
  vim.keymap.set("n", "gS", vim.lsp.buf.workspace_symbol, opts)
  local function _1_()
    return vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  end
  vim.keymap.set("n", "<tab>d", _1_, opts)
  local _3_
  do
    local partial_2_ = {count = -1, severity = vim.diagnostic.severity.ERROR}
    local function _4_(...)
      return vim.diagnostic.jump(partial_2_, ...)
    end
    _3_ = _4_
  end
  vim.keymap.set("n", "[D", _3_, opts)
  local _6_
  do
    local partial_5_ = {count = 1, severity = vim.diagnostic.severity.ERROR}
    local function _7_(...)
      return vim.diagnostic.jump(partial_5_, ...)
    end
    _6_ = _7_
  end
  return vim.keymap.set("n", "]D", _6_, opts)
end
M.gitsigns = function(bufid)
  local opts = {buffer = bufid}
  vim.keymap.set("n", "[h", "<Cmd>Gitsigns prev_hunk<CR>", opts)
  vim.keymap.set("n", "]h", "<Cmd>Gitsigns next_hunk<CR>", opts)
  vim.keymap.set("n", "<Tab>h", "<Cmd>Gitsigns preview_hunk<CR>", opts)
  vim.keymap.set("n", "<Leader>hb", "<Cmd>Gitsigns blame<CR>", opts)
  vim.keymap.set("n", "<Leader>hd", "<Cmd>Gitsigns diffthis<CR>", opts)
  vim.keymap.set("n", "<Leader>hl", "<Cmd>Gitsigns blame_line<CR>", opts)
  vim.keymap.set("n", "<Leader>hr", "<Cmd>Gitsigns reset_hunk<CR>", opts)
  vim.keymap.set("n", "<Leader>hs", "<Cmd>Gitsigns stage_hunk<CR>", opts)
  return vim.keymap.set("n", "<Leader>hv", "<Cmd>Gitsigns select_hunk<CR>", opts)
end
return M
