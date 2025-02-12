local M = {}

local do_map = function(mode, tbl)
  vim.validate({
    tbl = { tbl, 'table' },
  })

  local len = #tbl
  if len < 2 then
    vim.notify('keymap must has rhs', vim.log.levels.ERROR)
    return
  end

  local default_opts = {
    silent = true,
  }
  local opts = len == 3 and tbl[3] or default_opts

  vim.keymap.set(mode, tbl[1], tbl[2], opts)
end

local map = function(mod)
  return function(tbl)
    vim.validate({
      tbl = { tbl, 'table' },
    })

    if type(tbl[1]) == 'table' then
      for _, v in pairs(tbl) do
        do_map(mod, v)
      end
    else
      do_map(mod, tbl)
    end
  end
end

-- 按键映射 api
M.nmap = map('n')
M.vmap = map('v')
M.nvmap = map('')
M.imap = map('i')
M.tmap = map('t')

function M.todo()
  M.nmap({
    {
      '[t',
      function() require('todo-comments').jump_prev() end,
    },
    {
      ']t',
      function() require('todo-comments').jump_next() end,
    },
  })
end

function M.treesj()
  M.nmap({
    {
      '<Leader>j',
      function() require('treesj').toggle() end,
    },
  })
end

function M.window_picker()
  local picker = require('window-picker')
  M.nmap({
    {
      '<Leader>w',
      function()
        local picked_window_id = picker.pick_window() or vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(picked_window_id)
      end,
    },
  })
end

function M.fterm()
  local fterm = require('FTerm')
  -- gitui
  ---@diagnostic disable-next-line: missing-fields
  local gitui = fterm:new({
    ft = 'fterm_gitui', -- You can also override the default filetype, if you want
    cmd = 'gitui',
    ---@diagnostic disable-next-line: missing-fields
    dimensions = {
      height = 0.9,
      width = 0.9,
    },
  })

  M.nmap({
    { '<M-3>', '<Cmd>lua require("FTerm").toggle()<CR>' },
    {
      '<M-4>',
      function() gitui:toggle() end,
    },
  })
  M.tmap({
    { '<M-3>', '<C-\\><C-n><Cmd>lua require("FTerm").toggle()<CR>', { noremap = true } },
  })
end

function M.blink_cmp()
  return {
    preset = 'super-tab',
    ['<M-j>'] = { 'select_next', 'fallback' },
    ['<M-k>'] = { 'select_prev', 'fallback' },
    ['<C-c>'] = { 'hide', 'fallback' },
    ['<M-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
  }
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
    { 'gi', '<Cmd>lspsaga incoming_calls<CR>' },
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

function M.mini_notify()
  M.nvmap({ { '<Leader>n', function() MiniNotify.show_history() end } })
end

function M.mini_files()
  local yank_full_path = function()
    ---@diagnostic disable-next-line: undefined-global
    local path = MiniFiles.get_fs_entry().path
    vim.fn.setreg('+', path)
    -- Print path yanked
    print(path)
  end
  local yank_relative_path = function()
    ---@diagnostic disable-next-line: undefined-global
    local path = MiniFiles.get_fs_entry().path
    vim.fn.setreg('+', vim.fn.fnamemodify(path, ':.'))
    -- Print path yanked
    print(vim.fn.fnamemodify(path, ':.'))
  end

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      ---@diagnostic disable-next-line: missing-fields
      vim.keymap.set('n', 'gy', yank_full_path, { buffer = args.data.buf_id })
      ---@diagnostic disable-next-line: missing-fields
      vim.keymap.set('n', 'gY', yank_relative_path, { buffer = args.data.buf_id })
    end,
  })

  M.nmap({
    {
      '<M-1>',
      ---@diagnostic disable-next-line: undefined-global
      function() MiniFiles.open() end,
    },
    {
      '<M-2>',
      ---@diagnostic disable-next-line: undefined-global
      function() MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end,
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
    { '<Leader>fr', '<Cmd>Pick resume<CR>' },
    { '<Leader>fs', '<Cmd>Pick grep_live<CR>' },
    { '<Leader>h', '<Cmd>Pick help<CR>' },
    { '<Leader>r', '<Cmd>Pick registers<CR>' },
    -- mini.extras pickers
    { '<Leader>c', [[<Cmd>Pick list scope='change'<CR>]] },
    { '<Leader>d', '<Cmd>Pick diagnostic<CR>' },
    { '<Leader>J', [[<Cmd>Pick list scope='jump'<CR>]] },
    { '<Leader>fg', '<Cmd>Pick git_files<CR>' },
    { '<Leader>fv', '<Cmd>Pick visit_paths<CR>' },
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
    -- 退出
    { 'Q', '<Cmd>q<CR>' },
    { 'QQ', '<Cmd>q!<CR>' },

    -- delete current buffer
    { '<C-x>', '<Cmd>bd<CR>' },

    -- yank to system clipboard
    { '<C-v>', '"+p' },

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

    -- 选择全部
    { '<C-a>', 'gg<S-v>G' },

    -- 保存
    { '<C-s>', '<Cmd>w<CR>' },

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
  })

  M.vmap({
    --缩进
    { '<', '<gv' },
    { '>', '>gv' },

    -- 复制到剪贴板
    { '<C-c>', '"+y' },

    -- 退出 visual mode
    { '<C-[', '<Esc>' },
  })

  M.nvmap({
    -- 指针移动
    { 'J', '}' },
    { 'K', '{' },
    { 'H', '^' },
    { 'L', '$' },

    -- bufferlist
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

    -- changelist
    { '[c', 'g;' },
    { ']c', 'g,' },

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
