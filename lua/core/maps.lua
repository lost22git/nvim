local do_map = function(mode, tbl)
  vim.validate('tbl', tbl, 'table')

  if #tbl < 2 then
    vim.notify('Missing rhs, key="' .. tbl[1] .. '"', vim.log.levels.ERROR)
    return
  end

  local lhs, rhs = tbl[1], tbl[2]
  tbl[1], tbl[2] = nil, nil

  local default_opts = { silent = true }
  local opts = vim.tbl_extend('force', default_opts, tbl)

  vim.keymap.set(mode, lhs, rhs, opts)
end

local map = function(mod)
  return function(tbl)
    vim.validate('tbl', tbl, 'table')

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
    { 'gD', vim.lsp.buf.definition, unpack(opts) },
    { 'gk', vim.lsp.buf.hover, unpack(opts) },
    { 'gK', vim.lsp.buf.signature_help, unpack(opts) },
    { 'gT', vim.lsp.buf.type_definition, unpack(opts) },

    {
      '[D',
      function() vim.diagnostic.jump({ count = -1, float = false, severity = vim.diagnostic.severity.ERROR }) end,
      unpack(opts),
    },
    {
      ']D',
      function() vim.diagnostic.jump({ count = 1, float = false, severity = vim.diagnostic.severity.ERROR }) end,
      unpack(opts),
    },
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
    { 'gt', '<Cmd>Lspsaga peek_type_definition<CR>' },
  })
end

function M.mini_pick()
  local pick_zoxide = function()
    local show_icon = function(buf_id, items, query) MiniPick.default_show(buf_id, items, query, { show_icons = true }) end
    local on_choose = function(item)
      vim.cmd('cd ' .. item)
      vim.print('cd ' .. item)
    end
    local opts = { source = { name = 'Cd (zoxide)', show = show_icon, choose = on_choose } }
    local cmd = { 'zoxide', 'query', '-l' }
    return MiniPick.builtin.cli({ command = cmd }, opts)
  end

  M.nmap({
    { '<Leader>F', '<Cmd>Pick resume<CR>' },
    { '<Leader>fa', '<Cmd>Pick buf_lines<CR>' },
    { '<Leader>fb', '<Cmd>Pick buffers<CR>' },
    { '<Leader>ff', '<Cmd>Pick files<CR>' },
    { '<Leader>fs', '<Cmd>Pick grep_live<CR>' },
    { '<Leader>f;', '<Cmd>Pick help<CR>' },
    -- mini.extras pickers
    { '<Leader>fc', '<Cmd>Pick list scope="change"<CR>' },
    { '<Leader>fd', '<Cmd>Pick diagnostic<CR>' },
    { '<Leader>fe', '<Cmd>Pick oldfiles<CR>' },
    { '<Leader>fg', '<Cmd>Pick git_files<CR>' },
    { '<Leader>fh', '<Cmd>Pick git_hunks<CR>' },
    { '<Leader>fi', '<Cmd>Pick lsp scope="implementation"<CR>' },
    { '<Leader>fj', '<Cmd>Pick list scope="jump"<CR>' },
    { '<Leader>fk', '<Cmd>Pick keymaps<CR>' },
    { '<Leader>fl', '<Cmd>Pick list scope="location"<CR>' },
    { '<Leader>fo', '<Cmd>Pick lsp scope="document_symbol"<CR>' },
    { '<Leader>fq', '<Cmd>Pick list scope="quickfix"<CR>' },
    { '<Leader>fr', '<Cmd>Pick lsp scope="references"<CR>' },
    -- custom pickers
    { '<Leader>fz', pick_zoxide, desc = 'Pick zoxide' },
  })

  -- Pick justfile task
  local pick_justfile_task = function(justfile)
    local on_show = function(buf_id, items, query)
      local show_items = vim.tbl_map(function(item) return 'just ' .. item.name end, items)
      MiniPick.default_show(buf_id, show_items, query, {})
    end
    local opts = {
      source = {
        name = 'Tasks (just)',
        items = require('core.utils').get_justfile_tasks(justfile),
        show = on_show,
        choose = require('core.utils').run_justfile_task,
      },
    }
    return MiniPick.start(opts)
  end
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'just',
    callback = function()
      vim.keymap.set(
        'n',
        '<Leader>fj',
        function() pick_justfile_task(vim.fn.expand('%:p')) end,
        { buffer = true, desc = 'Pick justfile task' }
      )
    end,
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
    { 'U', '<C-r>', desc = 'Redo' },

    { '<BS><BS>', '<Cmd>noh<CR>', desc = 'Cancel highlight' },

    { '=', '<C-a>', desc = 'Increment number' },
    { '-', '<C-x>', desc = 'Decrement number' },

    { 'x', '"_x', desc = 'Delete char to blackhold' },

    { '<Tab><Tab>', '<Cmd>b #<CR>', desc = 'Buffer recent' },
    { '<Tab>b', '<Cmd>b #<CR>', desc = 'Buffer recent' },

    { '[<Tab>', '<Cmd>tabprevious<CR>', desc = 'Tab prev' },
    { ']<Tab>', '<Cmd>tabnext<CR>', desc = 'Tab next' },
    { '[<S-Tab>', '<Cmd>tabfirst<CR>', desc = 'Tab first' },
    { ']<S-Tab>', '<Cmd>tablast<CR>', desc = 'Tab last' },
  })

  M.vmap({
    { '<', '<gv', desc = 'Indent left' },
    { '>', '>gv', desc = 'Indent right' },

    { '<C-c>', '"+y', desc = 'Yank to clipboard' },
  })

  M.nvmap({
    { 'qq', '<Cmd>q<CR>', desc = 'Quit Neovim' },
    { 'Q', '<Cmd>q!<CR>', desc = 'Quit Neovim forcely' },

    { '<C-a>', 'gg<S-v>G', desc = 'Select all' },
    { '<C-s>', '<Cmd>w<CR>', desc = 'Save buffer' },
    { '<C-v>', '"+p', desc = 'Paste from clipboard' },
    { '<C-x>', '<Cmd>bd<CR>', desc = 'Delete buffer' },

    { '<C-h>', '<C-w>h', desc = 'Left window focused' },
    { '<C-k>', '<C-w>k', desc = 'Up window focused' },
    { '<C-j>', '<C-w>j', desc = 'Down window focused' },
    { '<C-l>', '<C-w>l', desc = 'Right window focused' },

    { '<C-M-h>', '<C-w><' },
    { '<C-M-l>', '<C-w>>' },
    { '<C-M-j>', '<C-w>+' },
    { '<C-M-k>', '<C-w>-' },
    { '<C-M-g>', '<C-w>=' },

    -- { '<C-[>', 'zh', desc = 'Zoom move Left' },
    -- { '<C-]>', 'zl', desc = 'Zoom move Right' },

    { '<Leader>J', 'J', desc = 'The old "J"' },
    { 'J', '}', desc = 'Goto next blank line' },
    { 'K', '{', desc = 'Goto prev blank line' },
    { 'H', '^', desc = 'Goto line head' },
    { 'L', '$', desc = 'Goto line tail' },

    -- Messages
    { '<Leader>m', create_messages_buf, desc = 'Messages' },
  })

  M.imap({
    { '<C-v>', '<Esc>"+pa', desc = 'Paste from clipboard' },

    -- Readline keymaps on Insert mode
    { '<C-a>', '<C-o>^', desc = 'Goto line head' },
    { '<C-b>', '<Left>', desc = 'Goto prev char' },
    { '<C-d>', '<Del>', desc = 'Delete next char' },
    { '<C-e>', '<C-o>$', desc = 'Goto line tail' },
    { '<C-f>', '<Right>', desc = 'Goto next char' },
    { '<C-k>', '<C-o>d$', desc = 'Delete to line tail' },
    { '<C-u>', '<C-o>d^', desc = 'Delete to line head' },
  })
  -- Readline keymaps on Cmdline mode
  M.cmap({
    { '<C-a>', '<Home>', silent = false, desc = 'Goto line begin' },
    { '<C-b>', '<Left>', silent = false, desc = 'Goto prev char' },
    { '<C-d>', '<Del>', silent = false, desc = 'Delete next char' },
    { '<C-f>', '<Right>', silent = false, desc = 'Goto next char' },
  })
end

M.base()

return M
