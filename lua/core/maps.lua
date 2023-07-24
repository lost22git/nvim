local M = {}

local default_opts = {
  silent = true
}

local do_map = function(mode, tbl)
  vim.validate({
    tbl = { tbl, 'table' }
  })
  local len = #tbl
  if len < 2 then
    vim.notify('keymap must has rhs', vim.log.levels.ERROR)
    return
  end

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

-- 基本按键映射
function M.base()
  M.nmap {
    -- 退出
    { 'qq',        ':q<CR>' },
    { 'Q',         ':q!<CR>' },
    { '<C-x>',     ':bd<CR>' },

    -- redo
    { 'U',         '<C-r>' },

    -- 清除最近一次搜索后的高亮
    { '<BS><BS>',  ':noh<CR>' },

    -- 开启/关闭 行号
    { '<Leader>n', ':set nu!<CR>' },

    -- start lsp client
    { '<Leader>l', '<cmd>LspStart<CR>' },

    -- Increment/decrement
    { '=',         '<C-a>' },
    { '-',         '<C-x>' },

    -- 删除
    { 'x',         '"_x' },
    { 'dw',        'vb"_d' },

    -- 选择全部
    { '<C-a>',     'gg<S-v>G' },

    -- 保存
    { '<C-s>',     ':w<CR>' },

    -- Tab edit
    { 'te',        ':tabedit' },

    -- Window move
    { '<C-h>',     '<C-w>h' },
    { '<C-k>',     '<C-w>k' },
    { '<C-j>',     '<C-w>j' },
    { '<C-l>',     '<C-w>l' },

    -- Window resize
    { '<C-M-h>',   '<C-w><' },
    { '<C-M-l>',   '<C-w>>' },
    { '<C-M-j>',   '<C-w>+' },
    { '<C-M-k>',   '<C-w>-' },
    { '<C-M-g>',   '<C-w>=' },

    -- Zoom move
    { '<C-[>',     'zh' },
    { '<C-]>',     'zl' },

    { '<C-v>',     '"+p' },
  }

  M.vmap {
    --缩进
    { '<',     '<gv' },
    { '>',     '>gv' },

    -- 复制到剪贴板
    { '<C-c>', '"+y' },

    -- 退出 visual mode
    { '<C-[',  '<Esc>' },
    { 'ii',    '<Esc>' },

  }

  M.nvmap {
    -- 指针移动
    { 'J', '}' },
    { 'K', '{' },
    { 'H', '^' },
    { 'L', '$' },
  }

  M.imap {
    { 'jk',    '<Esc>' },
    { '<C-h>', '<Esc>^i' },
    { '<C-l>', '<Esc>$a' },
    { '<C-a>', '<Home>' },
    { '<C-e>', '<End>' },
    { '<C-d>', '<Del>' },
    { '<M-h>', '<Left>' },
    { '<M-l>', '<Right>' },
  }
end

function M.telescope()
  local tel = require('telescope')
  local builtin = require('telescope.builtin')

  local function telescope_buffer_dir()
    return vim.fn.expand('%:p:h')
  end

  M.nmap {
    { '<Leader>fp', builtin.builtin },
    { '<Leader>fr', builtin.resume },
    { '<Leader>fM', builtin.man_pages },
    { '<Leader>fo', builtin.oldfiles },
    { '<Leader>ff', function()
      builtin.find_files({
        no_ignore = false,
        hidden = true
      })
    end
    },
    { '<Leader>fg', builtin.live_grep },
    { '<Leader>fb', builtin.buffers },
    { '<Leader>fh', builtin.help_tags },
    { '<Leader>fc', builtin.commands },
    { '<Leader>fC', builtin.command_history },
    { '<Leader>fk', builtin.keymaps },
    { '<Leader>fq', builtin.quickfix },
    { '<Leader>fQ', builtin.quickfixhistory },
    { "<Leader>fm", function()
      tel.extensions.file_browser.file_browser {
        path = "%:p:h",
        cwd = telescope_buffer_dir(),
        respect_gitignore = false,
        hidden = true,
        grouped = true,
        previewer = false,
        initial_mode = "normal",
        layout_config = { height = 40 }
      }
    end },

    -- TS
    { '<Leader>ft', builtin.treesitter },
    --  LSP
    { '<Leader>fe', builtin.diagnostics },
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

function M.telescope_file_browser_mappings()
  local tel = require 'telescope'
  return {
    ["i"] = {
      ['<C-k>'] = 'which_key',
    },
    ["n"] = {
      ['<C-k>'] = 'which_key',
      ["<bs>"] = function()
        tel.extensions.file_browser.actions.goto_parent_dir()
      end,
    },
  }
end

function M.barbar()
  M.nmap {
    { '<S-Tab>',    ':BufferPrevious<CR>' },
    { '<Tab>',      ':BufferNext<CR>' },
    { '{',          ':BufferMovePrevious<CR>' },
    { '}',          ':BufferMoveNext<CR>' },
    { '<leader>bb', ':BufferPick<CR>' },
    { '<leader>bd', ':BufferPickDelete<CR>' },
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
  })
end

function M.lsp(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  M.nmap {
    { '<Leader><Leader>f', vim.lsp.buf.format,                                                      opts },
    { "gs",                vim.lsp.buf.document_symbol,                                             opts },
    { "gS",                vim.lsp.buf.workspace_symbol,                                            opts },
    { 'gt',                vim.lsp.buf.type_definition,                                             opts },
    { 'gD',                vim.lsp.buf.declaration,                                                 opts },
    { 'gd',                vim.lsp.buf.definition,                                                  opts },
    { 'gi',                vim.lsp.buf.implementation,                                              opts },
    { 'gh',                vim.lsp.buf.hover,                                                       opts },
    { 'gH',                vim.lsp.buf.signature_help,                                              opts },
    { 'gR',                vim.lsp.buf.references,                                                  opts },
    { 'gr',                vim.lsp.buf.rename,                                                      opts },
    { 'ga',                vim.lsp.buf.code_action,                                                 opts },

    { 'ge',                vim.diagnostic.open_float,                                               opts },
    { '[e',                vim.diagnostic.goto_prev,                                                opts },
    { ']e',                vim.diagnostic.goto_next,                                                opts },
    { 'gq',                vim.diagnostic.setloclist,                                               opts },

    { 'gwa',               vim.lsp.buf.add_workspace_folder,                                        opts },
    { 'gwr',               vim.lsp.buf.remove_workspace_folder,                                     opts },
    { 'gwl',               function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts },
  }

  M.vmap {
    { 'ga', vim.lsp.buf.range_code_action, opts },
  }
end

function M.drex()
  M.nmap {
    { '<M-1>', '<cmd>DrexDrawerToggle<CR>' },
    { '<M-2>', '<cmd>DrexDrawerFindFileAndFocus<CR>' },
  }
end

function M.drex_keybindings()
  local expand_and_keep_focus = function()
    local line = vim.api.nvim_get_current_line()
    require("drex.elements").expand_element()
    if not require("drex.utils").is_directory(line) then
      require('drex.drawer').find_element('%', true, true)
    end
  end

  local system_open = function()
    local line = vim.api.nvim_get_current_line()
    local element = require('drex.utils').get_element(line)
    require('core.utils').system_open(element)
  end

  return {
    ['n'] = {
      ['v']             = 'V',
      ['X']             = { system_open, { desc = 'open the element in operation system' } },
      -- ['l']             = { '<cmd>lua require("drex.elements").expand_element()<CR>', { desc = 'expand element' } },
      ['l']             = { expand_and_keep_focus, { desc = 'expand element' } },
      ['h']             = { '<cmd>lua require("drex.elements").collapse_directory()<CR>',
        { desc = 'collapse directory' } },
      ['<right>']       = { '<cmd>lua require("drex.elements").expand_element()<CR>', { desc = 'expand element' } },
      ['<left>']        = { '<cmd>lua require("drex.elements").collapse_directory()<CR>',
        { desc = 'collapse directory' } },
      ['<2-LeftMouse>'] = { '<LeftMouse><cmd>lua require("drex.elements").expand_element()<CR>',
        { desc = 'expand element' } },
      ['<RightMouse>']  = { '<LeftMouse><cmd>lua require("drex.elements").collapse_directory()<CR>',
        { desc = 'collapse directory' } },
      ['<C-v>']         = { '<cmd>lua require("drex.elements").open_file("vs")<CR>', { desc = 'open file in vsplit' } },
      ['<C-x>']         = { '<cmd>lua require("drex.elements").open_file("sp")<CR>', { desc = 'open file in split' } },
      ['<C-t>']         = { '<cmd>lua require("drex.elements").open_file("tabnew", true)<CR>',
        { desc = 'open file in new tab' } },
      ['o']             = { '<cmd>lua require("drex.elements").open_directory()<CR>',
        { desc = 'open directory in new buffer' } },
      ['O']             = { '<cmd>lua require("drex.elements").open_parent_directory()<CR>',
        { desc = 'open parent directory in new buffer' } },
      ['<F5>']          = { '<cmd>lua require("drex").reload_directory()<CR>', { desc = 'reload' } },
      ['<C-r>']         = { '<cmd>lua require("drex").reload_directory()<CR>', { desc = 'reload' } },
      ['J']             = { '<cmd>lua require("drex.actions.jump").jump_to_next_sibling()<CR>',
        { desc = 'jump to next sibling' } },
      ['K']             = { '<cmd>lua require("drex.actions.jump").jump_to_prev_sibling()<CR>',
        { desc = 'jump to prev sibling' } },
      ['I']             = { '<cmd>lua require("drex.actions.jump").jump_to_parent()<CR>',
        { desc = 'jump to parent element' } },
      ['s']             = { '<cmd>lua require("drex.actions.stats").stats()<CR>', { desc = 'show element stats' } },
      ['a']             = { '<cmd>lua require("drex.actions.files").create()<CR>', { desc = 'create element' } },
      ['d']             = { '<cmd>lua require("drex.actions.files").delete("line")<CR>', { desc = 'delete element' } },
      ['D']             = { '<cmd>lua require("drex.actions.files").delete("clipboard")<CR>',
        { desc = 'delete (clipboard)' } },
      ['p']             = { '<cmd>lua require("drex.actions.files").copy_and_paste()<CR>',
        { desc = 'copy & paste (clipboard)' } },
      ['P']             = { '<cmd>lua require("drex.actions.files").cut_and_move()<CR>',
        { desc = 'cut & move (clipboard)' } },
      ['r']             = { '<cmd>lua require("drex.actions.files").rename()<CR>', { desc = 'rename element' } },
      ['R']             = { '<cmd>lua require("drex.actions.files").multi_rename("clipboard")<CR>',
        { desc = 'rename (clipboard)' } },
      ['/']             = { '<cmd>keepalt lua require("drex.actions.search").search()<CR>', { desc = 'search' } },
      ['M']             = { '<cmd>DrexMark<CR>', { desc = 'mark element' } },
      ['u']             = { '<cmd>DrexUnmark<CR>', { desc = 'unmark element' } },
      ['m']             = { '<cmd>DrexToggle<CR>', { desc = 'toggle element' } },
      ['cc']            = { '<cmd>lua require("drex.clipboard").clear_clipboard()<CR>', { desc = 'clear clipboard' } },
      ['cs']            = { '<cmd>lua require("drex.clipboard").open_clipboard_window()<CR>',
        { desc = 'edit clipboard' } },
      ['y']             = { '<cmd>lua require("drex.actions.text").copy_name()<CR>', { desc = 'copy element name' } },
      ['Y']             = { '<cmd>lua require("drex.actions.text").copy_relative_path()<CR>',
        { desc = 'copy element relative path' } },
      ['<C-y>']         = { '<cmd>lua require("drex.actions.text").copy_absolute_path()<CR>',
        { desc = 'copy element absolute path' } },
    },
    ['v'] = {
      ['d'] = { ':lua require("drex.actions.files").delete("visual")<CR>', { desc = 'delete elements' } },
      ['r'] = { ':lua require("drex.actions.files").multi_rename("visual")<CR>', { desc = 'rename elements' } },
      ['M'] = { ':DrexMark<CR>', { desc = 'mark elements' } },
      ['u'] = { ':DrexUnmark<CR>', { desc = 'unmark elements' } },
      ['m'] = { ':DrexToggle<CR>', { desc = 'toggle elements' } },
      ['y'] = { ':lua require("drex.actions.text").copy_name(true)<CR>', { desc = 'copy element names' } },
      ['Y'] = { ':lua require("drex.actions.text").copy_relative_path(true)<CR>',
        { desc = 'copy element relative paths' } },
      ['<C-y>'] = { ':lua require("drex.actions.text").copy_absolute_path(true)<CR>',
        { desc = 'copy element absolute paths' } },
    }
  }
end

function M.neotree()
  M.nmap {
    { '<M-1>', '<cmd>Neotree action=focus toggle<CR>' },
    { '<M-2>', '<cmd>Neotree action=focus toggle reveal<CR>' },
  }
end

function M.neotree_window_mappings()
  return {
    ["e"] = function() vim.api.nvim_exec("Neotree focus filesystem left", true) end,
    ["b"] = function() vim.api.nvim_exec("Neotree focus buffers left", true) end,
    ["g"] = function() vim.api.nvim_exec("Neotree focus git_status left", true) end,
    ["h"] = function(state)
      local node = state.tree:get_node()
      if node.type == 'directory' and node:is_expanded() then -- 关闭目录
        require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
      else                                                    -- cursor 移动到父节点
        require 'neo-tree.ui.renderer'.focus_node(state, node:get_parent_id())
      end
    end,
    ["l"] = function(state)
      local node = state.tree:get_node()
      if node.type == 'directory' then
        if not node:is_expanded() then  -- 打开目录
          require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
        elseif node:has_children() then -- cursor 移动到第一个子节点
          require 'neo-tree.ui.renderer'.focus_node(state, node:get_child_ids()[1])
        end
      else -- 打开文件
        require('neo-tree.sources.common.commands').open(state, node)
        vim.cmd('Neotree reveal')
      end
    end,
    ["<2-LeftMouse>"] = "open",
    ["<esc>"] = "revert_preview",
    ["P"] = { "toggle_preview", config = { use_float = true } },
    ["S"] = "open_split",
    ["s"] = "open_vsplit",
    ["t"] = "open_tabnew",
    -- ["<CR>"] = "open_drop",
    -- ["t"] = "open_tab_drop",
    ["w"] = "open_with_window_picker",
    ["C"] = "close_node",
    ["z"] = "close_all_nodes",
    ["Z"] = "expand_all_nodes",
    ["a"] = {
      "add",
      config = {
        show_path = "none" -- "none", "relative", "absolute"
      }
    },
    ["A"] = "add_directory",
    ["d"] = "delete",
    ["r"] = "rename",
    ["y"] = "copy_to_clipboard",
    ["x"] = "cut_to_clipboard",
    ["p"] = "paste_from_clipboard",
    ["c"] = "copy",
    ["m"] = "move",
    ["q"] = "close_window",
    ["R"] = "refresh",
    ["?"] = "show_help",
    ["<"] = "prev_source",
    [">"] = "next_source",
  }
end

function M.neotree_filesystem_window_mappings()
  local system_open = function(state)
    local node = state.tree:get_node()
    local path = node:get_id()
    require('core.utils').system_open(path)
  end

  return {
    ["O"]     = "navigate_up",
    ["o"]     = "set_root",
    ["H"]     = "toggle_hidden",
    ["/"]     = "fuzzy_finder",
    ["D"]     = "fuzzy_finder_directory",
    ["f"]     = "filter_on_submit",
    ["<c-x>"] = "clear_filter",
    ["[g"]    = "prev_git_modified",
    ["]g"]    = "next_git_modified",
    ["X"]     = system_open,
  }
end

function M.neotree_buffers_window_mappings()
  return {
    ["bd"] = "buffer_delete",
    ["O"] = "navigate_up",
    ["o"] = "set_root",
  }
end

function M.neotree_git_status_window_mappings()
  return {
    ["A"]  = "git_add_all",
    ["gu"] = "git_unstage_file",
    ["ga"] = "git_add_file",
    ["gr"] = "git_revert_file",
    ["gc"] = "git_commit",
    ["gp"] = "git_push",
    ["gg"] = "git_commit_and_push",
  }
end

function M.noice()
  M.nvmap {
    { '<M-9>', '<cmd>Noice<CR>' }
  }
  M.imap {
    { '<M-9>', '<cmd>Noice<CR>' }
  }
end

function M.lspsaga()
  M.nmap {
    { "<Leader>gg", "<cmd>Lspsaga lsp_finder<CR>" },
    { "<Leader>gh", "<cmd>Lspsaga hover_doc<CR>" },
    { "<Leader>gr", "<cmd>Lspsaga rename<CR>" },
    { "<Leader>gd", "<cmd>Lspsaga peek_definition<CR>" },
    -- { "<Leader>go", "<cmd>Lspsaga outline<CR>" },
    { "go",         "<cmd>Lspsaga incoming_calls<CR>" },
    { "gO",         "<cmd>Lspsaga outgoing_calls<CR>" },

    -- Diagnostic
    { "<Leader>ge", "<cmd>Lspsaga show_line_diagnostics<CR>" },
    { "gk",         "<cmd>Lspsaga diagnostic_jump_prev<CR>" },
    { "gj",         "<cmd>Lspsaga diagnostic_jump_next<CR>" },
    { "gK", function()
      require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end },
    { "gJ", function()
      require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
    end },

    { "<leader>gt", "<cmd>Lspsaga term_toggle<CR>" },
  }

  M.tmap {
    { "<leader>gt", "<cmd>Lspsaga term_toggle<CR>" },
  }

  M.nvmap {
    { "<Leader>ga", "<cmd>Lspsaga code_action<CR>" },
  }
end

function M.trouble()
  M.nmap {
    { '<M-8>',      '<cmd>TroubleToggle<CR>' },
    { '<leader>xx', '<cmd>TroubleToggle<CR>' },
    { '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<CR>' },
    { '<leader>xd', '<cmd>TroubleToggle document_diagnostics<CR>' },
    { '<leader>xq', '<cmd>TroubleToggle quickfix<CR>' },
    { '<leader>xl', '<cmd>TroubleToggle loclist<CR>' },
    { '<Leader>xr', '<cmd>TroubleToggle lsp_references<CR>' },
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

function M.move()
  M.nmap {
    { '<A-j>', ':MoveLine(1)<CR>' },
    { '<A-k>', ':MoveLine(-1)<CR>' },
    { '<A-h>', ':MoveHChar(-1)<CR>' },
    { '<A-l>', ':MoveHChar(1)<CR>' },
  }
  M.vmap {
    { '<A-j>', ':MoveBlock(1)<CR>' },
    { '<A-k>', ':MoveBlock(-1)<CR>' },
    { '<A-h>', ':MoveHBlock(-1)<CR>' },
    { '<A-l>', ':MoveHBlock(1)<CR>' },
  }
end

function M.presistence()
  M.nmap {
    { '<leader>ss', '<cmd>lua require("persistence").load()<CR>' },
    { '<leader>sa', '<cmd>lua require("persistence").load({ last = true })<CR>' },
    { '<leader>sd', '<cmd>lua require("persistence").stop()<CR>' },
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

function M.mini_files()
  M.nmap {
    { '<M-1>', function() MiniFiles.open() end },
    { '<M-2>', function() MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end }
  }
end

function M.outline()
  M.nmap {
    { '<leader>go', ':SymbolsOutline<CR>' }
  }
end

M.base()

return M
