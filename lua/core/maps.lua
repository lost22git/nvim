local M = {}

local do_map = function(mode, tbl)
  vim.validate({
    tbl = { tbl, 'table' }
  })

  local len = #tbl
  if len < 2 then
    vim.notify('keymap must has rhs', vim.log.levels.ERROR)
    return
  end

  local default_opts = {
    silent = true
  }
  local opts = len == 3 and tbl[3] or default_opts

  vim.keymap.set(mode, tbl[1], tbl[2], opts)
end

local map = function(mod)
  return function(tbl)
    vim.validate({
      tbl = { tbl, 'table' }
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

function M.noice()
  M.nvmap {
    { '<M-9>', '<cmd>Noice<CR>' }
  }
end

function M.move()
  M.nmap {
    { '<M-j>', ':MoveLine(1)<CR>' },
    { '<M-k>', ':MoveLine(-1)<CR>' },
    { '<M-h>', ':MoveHChar(-1)<CR>' },
    { '<M-l>', ':MoveHChar(1)<CR>' },
  }
  M.vmap {
    { '<M-j>', ':MoveBlock(1)<CR>' },
    { '<M-k>', ':MoveBlock(-1)<CR>' },
    { '<M-h>', ':MoveHBlock(-1)<CR>' },
    { '<M-l>', ':MoveHBlock(1)<CR>' },
  }
end

function M.todo()
  M.nmap {
    { '[t', function() require("todo-comments").jump_prev() end },
    { ']t', function() require("todo-comments").jump_next() end }
  }
end

function M.treesj()
  M.nmap {
    { '<leader>j', function() require('treesj').toggle() end },
  }
end

function M.window_picker()
  local picker = require('window-picker')
  M.nmap {
    { "<Leader>w", function()
      local picked_window_id = picker.pick_window() or vim.api.nvim_get_current_win()
      vim.api.nvim_set_current_win(picked_window_id)
    end },
  }
end

function M.fterm()
  local fterm = require('FTerm')
  -- gitui
  local gitui = fterm:new({
    ft = 'fterm_gitui', -- You can also override the default filetype, if you want
    cmd = "gitui",
    dimensions = {
      height = 0.9,
      width = 0.9
    }
  })

  M.nmap {
    { '<M-3>', '<cmd>lua require("FTerm").toggle()<CR>' },
    { '<M-4>', function() gitui:toggle() end }
  }
  M.tmap {
    { '<M-3>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { noremap = true } }
  }
end

function M.telescope()
  local builtin = require('telescope.builtin')

  M.nmap {
    { '<Leader>fa', builtin.builtin },
    { '<Leader>fr', builtin.resume },
    { '<Leader>fm', builtin.man_pages },
    { '<Leader>fe', builtin.oldfiles },
    { '<Leader>ff', function()
      builtin.find_files({
        no_ignore = false,
        hidden = true
      })
    end
    },
    { '<Leader>fg', builtin.live_grep },
    { '<Leader>bb', builtin.buffers },
    { '<Leader>fh', builtin.help_tags },
    { '<Leader>fc', builtin.commands },
    { '<Leader>fC', builtin.command_history },
    { '<Leader>fk', builtin.keymaps },
    { '<Leader>fq', builtin.quickfix },
    { '<Leader>fQ', builtin.quickfixhistory },

    -- TS
    { '<Leader>ft', builtin.treesitter },
    --  LSP
    { '<Leader>fd', builtin.diagnostics },
    { '<Leader>fs', builtin.lsp_document_symbols },
    { '<Leader>fS', builtin.lsp_workspace_symbols },
  }
end

function M.telescope_default_mapping()
  local actions = require 'telescope.actions'
  return {
    n = {
      ["C-c"] = actions.close,
      ["qq"] = actions.close,
    },
  }
end

function M.cmp()
  local cmp = require('cmp')

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  return cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<M-.>'] = cmp.mapping.complete(),
    ['<C-c>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        ---@diagnostic disable-next-line: missing-parameter
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<M-j>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        ---@diagnostic disable-next-line: missing-parameter
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's', 'c' }),
    ['<M-k>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's', 'c' }),

  })
end

function M.lsp(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  M.nmap {
    { 'gF',  vim.lsp.buf.format,                                                      opts },
    { "gs",  vim.lsp.buf.document_symbol,                                             opts },
    { "gS",  vim.lsp.buf.workspace_symbol,                                            opts },
    { 'gT',  vim.lsp.buf.type_definition,                                             opts },
    { 'gD',  vim.lsp.buf.definition,                                                  opts },
    { 'ge',  vim.lsp.buf.declaration,                                                 opts },
    { 'gR',  vim.lsp.buf.references,                                                  opts },
    { 'gI',  vim.lsp.buf.implementation,                                              opts },
    { 'gh',  vim.lsp.buf.hover,                                                       opts },
    { 'gH',  vim.lsp.buf.signature_help,                                              opts },

    -- use lspsaga.nvim to enhance it. see lspsaga()
    -- { 'ga',  vim.lsp.buf.code_action,                                                 opts },
    -- { 'gr',                vim.lsp.buf.rename,                                                      opts },

    -- use trouble.nvim and lspsaga.nvim to enhance it, see trouble() and lspsaga()
    -- { 'ge',                vim.diagnostic.open_float,                                               opts },
    -- { 'gk',                vim.diagnostic.goto_prev,                                                opts },
    -- { 'gj',                vim.diagnostic.goto_next,                                                opts },
    -- { 'gl',                vim.diagnostic.setloclist,                                               opts },

    { 'gwa', vim.lsp.buf.add_workspace_folder,                                        opts },
    { 'gwd', vim.lsp.buf.remove_workspace_folder,                                     opts },
    { 'gwl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts },
  }

  -- use lspsaga.nvim to enhance it. see lspsaga()
  -- M.vmap {
  -- { 'ga', vim.lsp.buf.range_code_action, opts },
  -- }
end

function M.trouble()
  M.nmap {
    { 'gx', '<cmd>Trouble diagnostics toggle<CR>' },
  }
end

function M.lspsaga()
  M.nvmap {
    -- code action
    { "ga", "<cmd>Lspsaga code_action<CR>" },
  }

  M.nmap {
    { "gf", "<cmd>Lspsaga finder<CR>" },
    { "gr", "<cmd>Lspsaga rename<CR>" },
    { "gd", "<cmd>Lspsaga peek_definition<CR>" },
    { "gO", "<cmd>Lspsaga outline<CR>" },
    { "gi", "<cmd>lspsaga incoming_calls<cr>" },
    { "go", "<cmd>Lspsaga outgoing_calls<CR>" },

    -- Diagnostic
    { "gk", "<cmd>Lspsaga diagnostic_jump_prev<CR>" },
    { "gj", "<cmd>Lspsaga diagnostic_jump_next<CR>" },
    { "gK", function()
      require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end },
    { "gJ", function()
      require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
    end },

    -- float terminal
    { "gt", "<cmd>Lspsaga term_toggle<CR>" },
  }

  M.tmap {
    -- float terminal
    { "gt", "<cmd>Lspsaga term_toggle<CR>" },
  }
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
      vim.keymap.set('n', 'gy', yank_full_path, { buffer = args.data.buf_id })
      vim.keymap.set('n', 'gY', yank_relative_path, { buffer = args.data.buf_id })
    end,
  })

  M.nmap {
    ---@diagnostic disable-next-line: undefined-global
    { '<M-1>', function() MiniFiles.open() end },
    ---@diagnostic disable-next-line: undefined-global
    { '<M-2>', function() MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end }
  }
end

function M.mini_pick()
  local U = require('core.utils')
  local pick_files = function()
    if U.on_win() then
      return MiniPick.builtin.files()
    else
      return MiniPick.builtin.files()

      -- local show_icon = function(buf_id, items, query) MiniPick.default_show(buf_id, items, query, { show_icons = true }) end
      --
      -- ---- use bfs
      -- local default_opts = { source = { name = string.format('Files (%s)', 'bfs'), show = show_icon } }
      -- local cmd = { 'bfs', '-type', 'f', '-nocolor', '-exclude', '-name', '.git' }
      --
      -- local opts = vim.tbl_deep_extend('force', default_opts, {})
      -- return MiniPick.builtin.cli({ command = cmd }, opts)
    end
  end

  M.nmap {
    { '<leader>ff', pick_files },
    { '<leader>fs', ':Pick grep_live<CR>' },
    { '<leader>fr', ':Pick resume<CR>' },
    { '<leader>bb', ':Pick buffers<CR>' },
    { '<leader>fh', ':Pick help<CR>' },
    -- mini.extras pickers
    { '<leader>fg', ':Pick git_files<CR>' },
    { '<leader>fe', ':Pick oldfiles<CR>' },
    { '<leader>fv', ':Pick visit_paths<CR>' },
  }
end

-- 基本按键映射
function M.base()
  M.nmap {
    -- 退出
    { 'qq',              ':q<CR>' },
    { 'Q',               ':q!<CR>' },
    { '<C-x>',           ':bd<CR>' },

    -- redo
    { 'U',               '<C-r>' },

    -- 清除最近一次搜索后的高亮
    { '<BS><BS>',        ':noh<CR>' },

    -- 开启/关闭 行号
    { '<Leader>n',       ':set nu!<CR>' },

    -- start lsp client
    { '<Leader><Enter>', '<cmd>LspStart<CR>' },
    { 'gl',              '<cmd>LspStart<CR>' },

    -- Increment/decrement
    { '=',               '<C-a>' },
    { '-',               '<C-x>' },

    -- 删除
    { 'x',               '"_x' },
    { 'dw',              'vb"_d' },

    -- 选择全部
    { '<C-a>',           'gg<S-v>G' },

    -- 保存
    { '<C-s>',           ':w<CR>' },

    -- Tab edit
    { 'te',              ':tabedit' },

    -- Window move
    { '<C-h>',           '<C-w>h' },
    { '<C-k>',           '<C-w>k' },
    { '<C-j>',           '<C-w>j' },
    { '<C-l>',           '<C-w>l' },

    -- Window resize
    { '<C-M-h>',         '<C-w><' },
    { '<C-M-l>',         '<C-w>>' },
    { '<C-M-j>',         '<C-w>+' },
    { '<C-M-k>',         '<C-w>-' },
    { '<C-M-g>',         '<C-w>=' },

    -- Zoom move
    { '<C-[>',           'zh' },
    { '<C-]>',           'zl' },

    { '<C-v>',           '"+p' },
  }

  M.vmap {
    --缩进
    { '<',     '<gv' },
    { '>',     '>gv' },

    -- 复制到剪贴板
    { '<C-c>', '"+y' },

    -- 退出 visual mode
    { '<C-[',  '<Esc>' },
    { 'a',     '<Esc>' },

  }

  M.nvmap {
    -- 指针移动
    { 'J',       '}' },
    { 'K',       '{' },
    { 'H',       '^' },
    { 'L',       '$' },

    -- tab
    { '<Tab>',   ':bnext<CR>' },
    { '<S-Tab>', ':bprev<CR>' },
  }

  M.imap {
    { 'jk',    '<Esc>' },
    { '<C-v>', '<Esc>"+pa' },
    { '<C-h>', '<Esc>^i' },
    { '<C-l>', '<Esc>$a' },
    { '<C-a>', '<Home>' },
    { '<C-e>', '<End>' },
    { '<C-d>', '<Del>' },
    { '<C-b>', '<Left>' },
    { '<C-f>', '<Right>' },
  }
end

M.base()

return M
