-- [nfnl] fnl/core/maps.fnl
local function base()
  vim.keymap.set("n", "U", "<C-r>", {desc = "[base] Redo"})
  vim.keymap.set("n", "<BS><BS>", "<Cmd>noh<CR>", {desc = "[base] Cancel highlight"})
  vim.keymap.set("n", "=", "<C-a>", {desc = "[base] Increment number"})
  vim.keymap.set("n", "-", "<C-x>", {desc = "[base] Decrement number"})
  vim.keymap.set("n", "x", "\"_x", {desc = "[base] Delete char to blackhold"})
  vim.keymap.set("n", "<Tab>b", "<Cmd>b #<CR>", {desc = "[base] Buffer recent"})
  vim.keymap.set("n", "[<Tab>", "<Cmd>tabprevious<CR>", {desc = "[base] Tab prev"})
  vim.keymap.set("n", "]<Tab>", "<Cmd>tabnext<CR>", {desc = "[base] Tab next"})
  vim.keymap.set("n", "[<S-Tab>", "<Cmd>tabfirst<CR>", {desc = "[base] Tab first"})
  vim.keymap.set("n", "]<S-Tab>", "<Cmd>tablast<CR>", {desc = "[base] Tab last"})
  vim.keymap.set("i", "<C-v>", "<Esc>\"+pa", {desc = "[base] Paste from clipboard"})
  vim.keymap.set("v", "<", "<gv", {desc = "[base] Indent left"})
  vim.keymap.set("v", ">", ">gv", {desc = "[base] Indent right"})
  vim.keymap.set("v", "<C-c>", "\"+y", {desc = "[base] Yank to clipboard"})
  vim.keymap.set({"n", "v"}, "`", "q", {desc = "[base] The old `q`"})
  vim.keymap.set({"n", "v"}, "q", "<Nop>")
  vim.keymap.set({"n", "v"}, "qq", "<Cmd>q<CR>", {desc = "[base] Quit Neovim"})
  vim.keymap.set({"n", "v"}, "Q", "<Cmd>q!<CR>", {desc = "[base] Quit Neovim forcely"})
  vim.keymap.set({"n", "v"}, "<C-s>", "<Cmd>w<CR>", {desc = "[base] Save buffer"})
  vim.keymap.set({"n", "v"}, "<C-v>", "\"+p", {desc = "[base] Paste from clipboard"})
  vim.keymap.set({"n", "v"}, "<C-x>", "<Cmd>bd<CR>", {desc = "[base] Delete buffer"})
  vim.keymap.set({"n", "v"}, "<C-h>", "<C-w>h", {desc = "[base] Focus left window"})
  vim.keymap.set({"n", "v"}, "<C-k>", "<C-w>k", {desc = "[base] Focus up window"})
  vim.keymap.set({"n", "v"}, "<C-j>", "<C-w>j", {desc = "[base] Focus down window"})
  vim.keymap.set({"n", "v"}, "<C-l>", "<C-w>l", {desc = "[base] Focus right window"})
  vim.keymap.set({"n", "v"}, "<C-M-h>", "<C-w><", {desc = "[base] Resize window"})
  vim.keymap.set({"n", "v"}, "<C-M-l>", "<C-w>>", {desc = "[base] Resize window"})
  vim.keymap.set({"n", "v"}, "<C-M-j>", "<C-w>+", {desc = "[base] Resize window"})
  vim.keymap.set({"n", "v"}, "<C-M-k>", "<C-w>-", {desc = "[base] Resize window"})
  vim.keymap.set({"n", "v"}, "<C-M-g>", "<C-w>=", {desc = "[base] Resize window"})
  vim.keymap.set({"n", "v", "o"}, "<C-a>", "gg<S-v>G", {desc = "[base] Select all"})
  vim.keymap.set({"n", "v", "o"}, "<Leader>J", "J", {desc = "[base] The old `J`"})
  vim.keymap.set({"n", "v", "o"}, "J", "}", {desc = "[base] Goto next blank line"})
  vim.keymap.set({"n", "v", "o"}, "K", "{", {desc = "[base] Goto prev blank line"})
  vim.keymap.set({"n", "v", "o"}, "H", "^", {desc = "[base] Goto line head"})
  vim.keymap.set({"n", "v", "o"}, "L", "$", {desc = "[base] Goto line tail"})
  return vim.keymap.set({"n", "v", "o"}, "mm", "%", {desc = "[base] The old `%`"})
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
local function highlight_visual()
  local nsid = vim.api.nvim_create_namespace("zz_highlight_visual")
  local function do_highlight_visual()
    vim.api.nvim_buf_clear_namespace(0, nsid, 0, -1)
    local mode = vim.fn.mode()
    if ("n" == mode) then
      return
    else
    end
    local function _4_()
      if (mode == "V") then
        local lc = vim.fn.line(".")
        local lp = vim.fn.line("v")
        if (lc > lp) then
          return {{(lp - 1), 0}, {(lc - 1), vim.v.maxcol}}
        else
          return {{(lc - 1), 0}, {(lp - 1), vim.v.maxcol}}
        end
      else
        local _ = mode
        local pc = vim.fn.getpos(".")
        local pp = vim.fn.getpos("v")
        local pcl = pc[2]
        local pcc = pc[3]
        local ppl = pp[2]
        local ppc = pp[3]
        if ((pcl > ppl) or ((pcl == ppl) and (pcc > ppc))) then
          return {{(ppl - 1), (ppc - 1)}, {(pcl - 1), pcc}}
        else
          return {{(pcl - 1), (pcc - 1)}, {(ppl - 1), ppc}}
        end
      end
    end
    local _local_5_ = _4_()
    local begin = _local_5_[1]
    local finish = _local_5_[2]
    vim.hl.range(0, nsid, "Visual", begin, finish)
    return vim.cmd("exe \"normal \\<Esc>\"")
  end
  return vim.keymap.set({"n", "v"}, "<Leader>v", do_highlight_visual, {desc = "[base] Highlight Visual"})
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
  return vim.keymap.set({"n", "v"}, "<Leader>m", create_messages_buf, {desc = "[base] Messages"})
end
base()
readline()
highlight_visual()
messages()
local M = {}
M.lsp = function(bufid)
  local opts = {buffer = bufid}
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gk", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol, opts)
  vim.keymap.set("n", "gS", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
  local _7_
  do
    local _6_ = {count = -1, severity = vim.diagnostic.severity.ERROR, float = false}
    local function _8_(...)
      return vim.diagnostic.jump(_6_, ...)
    end
    _7_ = _8_
  end
  vim.keymap.set("n", "[D", _7_, opts)
  local _10_
  do
    local _9_ = {count = 1, severity = vim.diagnostic.severity.ERROR, float = false}
    local function _11_(...)
      return vim.diagnostic.jump(_9_, ...)
    end
    _10_ = _11_
  end
  return vim.keymap.set("n", "]D", _10_, opts)
end
M.gitsigns = function(bufid)
  local opts = {buffer = bufid}
  vim.keymap.set("n", "[h", "<Cmd>Gitsigns prev_hunk<CR>", opts)
  vim.keymap.set("n", "]h", "<Cmd>Gitsigns next_hunk<CR>", opts)
  vim.keymap.set("n", "<Tab>h", "<Cmd>Gitsigns preview_hunk<CR>", opts)
  vim.keymap.set("n", "hr", "<Cmd>Gitsigns reset_hunk<CR>", opts)
  vim.keymap.set("n", "hs", "<Cmd>Gitsigns stage_hunk<CR>", opts)
  return vim.keymap.set("n", "hv", "<Cmd>Gitsigns select_hunk<CR>", opts)
end
return M
