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

M.nvomap = map({ 'n', 'v', 'o' })
M.nmap = map('n')
M.vmap = map('v')
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
    { 'gs', vim.lsp.buf.document_symbol, unpack(opts) },
    { 'gS', vim.lsp.buf.workspace_symbol, unpack(opts) },
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
    { '<Leader>fp', '<Cmd>Pick hipatterns<CR>' },
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
        { buffer = true, desc = '[mini.pick] Pick justfile task' }
      )
    end,
  })
end

local function base()
  M.nmap({
    { 'U', '<C-r>', desc = '[base] Redo' },

    { '<BS><BS>', '<Cmd>noh<CR>', desc = '[base] Cancel highlight' },

    { '=', '<C-a>', desc = '[base] Increment number' },
    { '-', '<C-x>', desc = '[base] Decrement number' },

    { 'x', '"_x', desc = '[base] Delete char to blackhold' },

    { '<Tab>b', '<Cmd>b #<CR>', desc = '[base] Buffer recent' },

    { '[<Tab>', '<Cmd>tabprevious<CR>', desc = '[base] Tab prev' },
    { ']<Tab>', '<Cmd>tabnext<CR>', desc = '[base] Tab next' },
    { '[<S-Tab>', '<Cmd>tabfirst<CR>', desc = '[base] Tab first' },
    { ']<S-Tab>', '<Cmd>tablast<CR>', desc = '[base] Tab last' },
  })

  M.vmap({
    { '<', '<gv', desc = '[base] Indent left' },
    { '>', '>gv', desc = '[base] Indent right' },

    { '<C-c>', '"+y', desc = '[base] Yank to clipboard' },
  })

  M.nvomap({
    { '`', 'q', desc = '[base] The old "q"' },
    { 'q', '<Nop>' },
    { 'qq', '<Cmd>q<CR>', desc = '[base] Quit Neovim' },
    { 'Q', '<Cmd>q!<CR>', desc = '[base] Quit Neovim forcely' },

    { '<C-a>', 'gg<S-v>G', desc = '[base] Select all' },
    { '<C-s>', '<Cmd>w<CR>', desc = '[base] Save buffer' },
    { '<C-v>', '"+p', desc = '[base] Paste from clipboard' },
    { '<C-x>', '<Cmd>bd<CR>', desc = '[base] Delete buffer' },

    { '<C-h>', '<C-w>h', desc = '[base] Focus left window' },
    { '<C-k>', '<C-w>k', desc = '[base] Focus up window' },
    { '<C-j>', '<C-w>j', desc = '[base] Focus down window' },
    { '<C-l>', '<C-w>l', desc = '[base] Focus right window' },

    { '<C-M-h>', '<C-w><', desc = '[base] Resize window' },
    { '<C-M-l>', '<C-w>>', desc = '[base] Resize window' },
    { '<C-M-j>', '<C-w>+', desc = '[base] Resize window' },
    { '<C-M-k>', '<C-w>-', desc = '[base] Resize window' },
    { '<C-M-g>', '<C-w>=', desc = '[base] Resize window' },

    { '<Leader>J', 'J', desc = '[base] The old "J"' },
    { 'J', '}', desc = '[base] Goto next blank line' },
    { 'K', '{', desc = '[base] Goto prev blank line' },
    { 'H', '^', desc = '[base] Goto line head' },
    { 'L', '$', desc = '[base] Goto line tail' },

    -- inspired by helix
    { 'mm', '%', desc = '[base] The old "%"' },
  })

  M.imap({ { '<C-v>', '<Esc>"+pa', desc = '[base] Paste from clipboard' } })
end

local function readline()
  M.imap({
    { '<C-a>', '<C-o>^', desc = '[readline] Goto line head' },
    { '<C-b>', '<Left>', desc = '[readline] Goto prev char' },
    { '<C-d>', '<Del>', desc = '[readline] Delete next char' },
    { '<C-e>', '<C-o>$', desc = '[readline] Goto line tail' },
    { '<C-f>', '<Right>', desc = '[readline] Goto next char' },
    { '<C-k>', '<C-o>d$', desc = '[readline] Delete to line tail' },
    { '<C-u>', '<C-o>d^', desc = '[readline] Delete to line head' },
  })
  M.cmap({
    { '<C-a>', '<Home>', silent = false, desc = '[readline] Goto line begin' },
    { '<C-b>', '<Left>', silent = false, desc = '[readline] Goto prev char' },
    { '<C-d>', '<Del>', silent = false, desc = '[readline] Delete next char' },
    { '<C-f>', '<Right>', silent = false, desc = '[readline] Goto next char' },
  })
end

local function highlight_visual()
  local ns = vim.api.nvim_create_namespace('zz_highlight_visual')
  local highlight_visual_fn = function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    local mode = vim.fn.mode()
    if mode == 'n' then return end -- N mode
    local begin, finish -- range to highlight
    if mode == 'V' then -- V_LINE mode
      local lc = vim.fn.line('.')
      local lp = vim.fn.line('v')
      begin, finish = { lc - 1, 0 }, { lp - 1, vim.v.maxcol }
      if lc > lp then
        begin, finish = { lp - 1, 0 }, { lc - 1, vim.v.maxcol }
      end
    else -- V or V_BLOCK mode
      local pc = vim.fn.getpos('.')
      local pp = vim.fn.getpos('v')
      begin, finish = { pc[2] - 1, pc[3] - 1 }, { pp[2] - 1, pp[3] }
      if pc[2] > pp[2] or (pc[2] == pp[2] and pc[3] > pp[3]) then
        begin, finish = { pp[2] - 1, pp[3] - 1 }, { pc[2] - 1, pc[3] }
      end
    end
    vim.hl.range(0, ns, 'Visual', begin, finish)
    vim.cmd('exe  "normal \\<Esc>"')
  end

  M.nvomap({ '<Leader>v', highlight_visual_fn, desc = '[base] Highlight Visual' })
end

local function messages()
  local create_messages_buf = function()
    local scratch_buffer = vim.api.nvim_create_buf(false, true)
    vim.bo[scratch_buffer].filetype = 'messages'
    local messages_text = vim.split(vim.fn.execute('messages', 'silent'), '\n')
    vim.api.nvim_buf_set_text(scratch_buffer, 0, 0, 0, 0, messages_text)
    vim.cmd('horizontal sbuffer ' .. scratch_buffer)
    vim.opt_local.wrap = true
    vim.bo.buflisted = false
    vim.bo.bufhidden = 'wipe'
  end

  M.nvomap({ '<Leader>m', create_messages_buf, desc = '[base] Messages' })
end

base()
readline()
highlight_visual()
messages()

return M
