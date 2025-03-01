local do_map = function(mode, tbl)
  vim.validate({
    tbl = { tbl, 'table' },
  })

  local len = #tbl
  if len < 2 then
    vim.notify('Missing rhs, key="' .. tbl[1] .. '"', vim.log.levels.ERROR)
    return
  end

  local default_opts = { silent = true }
  local opts = len == 3 and tbl[3] or default_opts

  vim.keymap.set(mode, tbl[1], tbl[2], opts)
end

local map = function(mod)
  return function(tbl)
    vim.validate({ tbl = { tbl, 'table' } })

    if type(tbl[1]) == 'table' then
      for _, v in pairs(tbl) do
        do_map(mod, v)
      end
    else
      do_map(mod, tbl)
    end
  end
end

local M = {}

-- 按键映射 api
M.nvmap = map('')
M.nmap = map('n')
M.vmap = map('v')
M.icmap = map({ 'i', 'c' })
M.imap = map('i')
M.cmap = map('c')
M.tmap = map('t')

function M.gitsigns()
  M.nmap({
    { '[h', '<Cmd>Gitsigns prev_hunk<CR>' },
    { ']h', '<Cmd>Gitsigns next_hunk<CR>' },
    { '<Tab>h', '<Cmd>Gitsigns preview_hunk<CR>' },
    { '<Leader>hh', '<Cmd>Gitsigns nav_hunk<CR>' },
    { '<Leader>hr', '<Cmd>Gitsigns reset_hunk<CR>' },
    { '<Leader>hs', '<Cmd>Gitsigns stage_hunk<CR>' },
    { '<Leader>hv', '<Cmd>Gitsigns select_hunk<CR>' },
  })
end

function M.lsp(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  M.nmap({
    { 'gD', vim.lsp.buf.definition, opts },
    { 'gh', vim.lsp.buf.hover, opts },
    { 'gH', vim.lsp.buf.signature_help, opts },
    { 'gT', vim.lsp.buf.type_definition, opts },
    { 'gR', vim.lsp.buf.references, opts },
    { 'gI', vim.lsp.buf.implementation, opts },
  })
end

function M.lspsaga()
  M.nmap({
    { 'ga', '<Cmd>Lspsaga code_action<CR>' },
    { 'gd', '<Cmd>Lspsaga peek_definition<CR>' },
    { 'gf', '<Cmd>Lspsaga finder<CR>' },
    { 'gi', '<Cmd>Lspsaga incoming_calls<CR>' },
    { 'go', '<Cmd>Lspsaga outgoing_calls<CR>' },
    { 'gO', '<Cmd>Lspsaga outline<CR>' },
    { 'gr', '<Cmd>Lspsaga rename<CR>' },
    { 'gt', '<Cmd>Lspsaga peek_type_definition<CR>' },
    { '[d', '<Cmd>Lspsaga diagnostic_jump_prev<CR>' },
    { ']d', '<Cmd>Lspsaga diagnostic_jump_next<CR>' },
    {
      '[D',
      function() require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
    },
    {
      ']D',
      function() require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
    },
  })
end

function M.mini_pick()
  local U = require('core.utils')
  local use_bfs = function()
    local show_icon = function(buf_id, items, query) MiniPick.default_show(buf_id, items, query, { show_icons = true }) end
    ---- use bfs
    local default_opts = { source = { name = string.format('Files (%s)', 'bfs'), show = show_icon } }
    local cmd = { 'bfs', '-type', 'f', '-nocolor', '-exclude', '-name', '.git' }
    local opts = vim.tbl_deep_extend('force', default_opts, {})
    return MiniPick.builtin.cli({ command = cmd }, opts)
  end
  local use_default = function() return MiniPick.builtin.files() end

  local pick_files = U.on_win() and use_default or use_default

  M.nmap({
    { '<Leader>fe', '<Cmd>Pick oldfiles<CR>' },
    { '<Leader>ff', pick_files },
    { '<Leader>fh', '<Cmd>Pick help<CR>' },
    { '<Leader>fr', '<Cmd>Pick resume<CR>' },
    { '<Leader>fs', '<Cmd>Pick grep_live<CR>' },
    -- mini.extras pickers
    { '<Leader>fc', [[<Cmd>Pick list scope='change'<CR>]] },
    { '<Leader>fd', '<Cmd>Pick diagnostic<CR>' },
    { '<Leader>fj', [[<Cmd>Pick list scope='jump'<CR>]] },
    { '<Leader>fg', '<Cmd>Pick git_files<CR>' },
  })
end

-- 基本按键映射
function M.base()
  local create_messages_buf = function()
    local scratch_buffer = vim.api.nvim_create_buf(false, true)
    vim.bo[scratch_buffer].filetype = 'messages'
    local messages = vim.split(vim.fn.execute('messages', 'silent'), '\n')
    vim.api.nvim_buf_set_text(scratch_buffer, 0, 0, 0, 0, messages)
    vim.cmd('horizontal sbuffer ' .. scratch_buffer)
    vim.opt_local.wrap = true
    vim.bo.buflisted = false
    vim.bo.bufhidden = 'wipe'
  end

  M.nmap({

    -- redo
    { 'U', '<C-r>' },

    -- 清除最近一次搜索后的高亮
    { '<BS><BS>', '<Cmd>noh<CR>' },

    -- start lsp client
    { 'gl', '<Cmd>LspStart<CR>' },

    -- Increment/decrement
    { '=', '<C-a>' },
    { '-', '<C-x>' },

    -- 删除
    { 'x', '"_x' },
    { 'dw', 'vb"_d' },
  })

  M.vmap({
    --缩进
    { '<', '<gv' },
    { '>', '>gv' },

    -- 复制到剪贴板
    { '<C-c>', '"+y' },

    -- 退出 visual mode
    { '<C-[', '<Esc>' },

    -- goto and select next word
    { 'nw', '<Esc>wviw' },
    -- goto and select prev word
    { 'lw', '<Esc>bbviw' },
  })

  M.nvmap({
    { '`', 'q' },
    { 'q', '<Nop>' },

    -- 退出
    { 'Q', '<Cmd>q<CR>' },
    { 'QQ', '<Cmd>q!<CR>' },

    -- 保存
    { '<C-s>', '<Cmd>w<CR>' },

    -- delete current buffer
    { '<C-x>', '<Cmd>bd<CR>' },

    -- yank to system clipboard
    { '<C-v>', '"+p' },

    -- 选择全部
    { '<C-a>', 'gg<S-v>G' },

    -- Window move
    { '<C-h>', '<C-w>h' },
    { '<C-k>', '<C-w>k' },
    { '<C-j>', '<C-w>j' },
    { '<C-l>', '<C-w>l' },

    -- Window resize
    { '<C-M-h>', '<C-w><' },
    { '<C-M-l>', '<C-w>>' },
    { '<C-M-j>', '<C-w>+' },
    { '<C-M-k>', '<C-w>-' },
    { '<C-M-g>', '<C-w>=' },

    -- Zoom move
    { '<C-[>', 'zh' },
    { '<C-]>', 'zl' },

    -- 指针移动
    { 'J', '}' },
    { 'K', '{' },
    { 'H', '^' },
    { 'L', '$' },

    -- bufferlist
    { '<Tab><Tab>', '<Cmd>b #<CR>' },
    { '[b', '<Cmd>bprev<CR>' },
    { ']b', '<Cmd>bnext<CR>' },
    { '[B', '<Cmd>bfirst<CR>' },
    { ']B', '<Cmd>blast<CR>' },

    -- quickfixlist
    { '[q', '<Cmd>cprevious<CR>' },
    { ']q', '<Cmd>cnext<CR>' },
    { '[Q', '<Cmd>cfirst<CR>' },
    { ']Q', '<Cmd>clast<CR>' },

    -- locallist
    { '[l', '<Cmd>lprevious<CR>' },
    { ']l', '<Cmd>lnext<CR>' },
    { '[L', '<Cmd>lfirst<CR>' },
    { ']L', '<Cmd>llast<CR>' },

    -- messages
    { '<Leader>m', create_messages_buf },
  })

  M.imap({
    { 'jk', '<Esc>' },
    { '<C-v>', '<Esc>"+pa' },
    { '<C-h>', '<Esc>^i' },
    { '<C-l>', '<Esc>$a' },
    { '<C-a>', '<Home>' },
    { '<C-e>', '<End>' },
    { '<C-d>', '<Del>' },
    { '<C-b>', '<Left>' },
    { '<C-f>', '<Right>' },
    { '<C-k>', '<Esc>ld$a' },
  })
end

M.base()

return M
