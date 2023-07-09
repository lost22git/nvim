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
    { 'qq',        ':q<cr>' },
    { 'Q',         ':q!<cr>' },
    { '<C-x>',     ':bd<cr>' },

    -- redo
    { 'U',         '<C-r>' },

    -- 清除最近一次搜索后的高亮
    { '<BS><BS>',  ':noh<cr>' },

    -- 开启/关闭 行号
    { '<Leader>n', ':set nu!<cr>' },

    -- start lsp client
    { '<Leader>l', '<cmd>LspStart<cr>' },

    -- Increment/decrement
    { '=',         '<C-a>' },
    { '-',         '<C-x>' },

    -- 删除
    { 'x',         '"_x' },
    { 'dw',        'vb"_d' },

    -- 选择全部
    { '<C-a>',     'gg<S-v>G' },

    -- 保存
    { '<C-s>',     ':w<cr>' },

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

function M.bufferline()
  M.nmap {
    { '<Tab>',     ':BufferLineCycleNext<cr>' },
    { '<S-Tab>',   ':BufferLineCyclePrev<cr>' },
    { '<Leader>b', ':BufferLinePick<cr>' },

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
    { '<M-3>', '<cmd>lua require("FTerm").toggle()<cr>' },
    { '<M-4>', function() gitui:toggle() end }
  }
  M.tmap {
    { '<M-3>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<cr>', { noremap = true } }
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
    ['<cr>'] = cmp.mapping.confirm({
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
    { '<M-1>', '<cmd>DrexDrawerToggle<cr>' },
    { '<M-2>', '<cmd>DrexDrawerFindFileAndFocus<cr>' },
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
      -- ['l']             = { '<cmd>lua require("drex.elements").expand_element()<cr>', { desc = 'expand element' } },
      ['l']             = { expand_and_keep_focus, { desc = 'expand element' } },
      ['h']             = { '<cmd>lua require("drex.elements").collapse_directory()<cr>',
        { desc = 'collapse directory' } },
      ['<right>']       = { '<cmd>lua require("drex.elements").expand_element()<cr>', { desc = 'expand element' } },
      ['<left>']        = { '<cmd>lua require("drex.elements").collapse_directory()<cr>',
        { desc = 'collapse directory' } },
      ['<2-LeftMouse>'] = { '<LeftMouse><cmd>lua require("drex.elements").expand_element()<cr>',
        { desc = 'expand element' } },
      ['<RightMouse>']  = { '<LeftMouse><cmd>lua require("drex.elements").collapse_directory()<cr>',
        { desc = 'collapse directory' } },
      ['<C-v>']         = { '<cmd>lua require("drex.elements").open_file("vs")<cr>', { desc = 'open file in vsplit' } },
      ['<C-x>']         = { '<cmd>lua require("drex.elements").open_file("sp")<cr>', { desc = 'open file in split' } },
      ['<C-t>']         = { '<cmd>lua require("drex.elements").open_file("tabnew", true)<cr>',
        { desc = 'open file in new tab' } },
      ['o']             = { '<cmd>lua require("drex.elements").open_directory()<cr>',
        { desc = 'open directory in new buffer' } },
      ['O']             = { '<cmd>lua require("drex.elements").open_parent_directory()<cr>',
        { desc = 'open parent directory in new buffer' } },
      ['<F5>']          = { '<cmd>lua require("drex").reload_directory()<cr>', { desc = 'reload' } },
      ['<C-r>']         = { '<cmd>lua require("drex").reload_directory()<cr>', { desc = 'reload' } },
      ['J']             = { '<cmd>lua require("drex.actions.jump").jump_to_next_sibling()<cr>',
        { desc = 'jump to next sibling' } },
      ['K']             = { '<cmd>lua require("drex.actions.jump").jump_to_prev_sibling()<cr>',
        { desc = 'jump to prev sibling' } },
      ['I']             = { '<cmd>lua require("drex.actions.jump").jump_to_parent()<cr>',
        { desc = 'jump to parent element' } },
      ['s']             = { '<cmd>lua require("drex.actions.stats").stats()<cr>', { desc = 'show element stats' } },
      ['a']             = { '<cmd>lua require("drex.actions.files").create()<cr>', { desc = 'create element' } },
      ['d']             = { '<cmd>lua require("drex.actions.files").delete("line")<cr>', { desc = 'delete element' } },
      ['D']             = { '<cmd>lua require("drex.actions.files").delete("clipboard")<cr>',
        { desc = 'delete (clipboard)' } },
      ['p']             = { '<cmd>lua require("drex.actions.files").copy_and_paste()<cr>',
        { desc = 'copy & paste (clipboard)' } },
      ['P']             = { '<cmd>lua require("drex.actions.files").cut_and_move()<cr>',
        { desc = 'cut & move (clipboard)' } },
      ['r']             = { '<cmd>lua require("drex.actions.files").rename()<cr>', { desc = 'rename element' } },
      ['R']             = { '<cmd>lua require("drex.actions.files").multi_rename("clipboard")<cr>',
        { desc = 'rename (clipboard)' } },
      ['/']             = { '<cmd>keepalt lua require("drex.actions.search").search()<cr>', { desc = 'search' } },
      ['M']             = { '<cmd>DrexMark<cr>', { desc = 'mark element' } },
      ['u']             = { '<cmd>DrexUnmark<cr>', { desc = 'unmark element' } },
      ['m']             = { '<cmd>DrexToggle<cr>', { desc = 'toggle element' } },
      ['cc']            = { '<cmd>lua require("drex.clipboard").clear_clipboard()<cr>', { desc = 'clear clipboard' } },
      ['cs']            = { '<cmd>lua require("drex.clipboard").open_clipboard_window()<cr>',
        { desc = 'edit clipboard' } },
      ['y']             = { '<cmd>lua require("drex.actions.text").copy_name()<cr>', { desc = 'copy element name' } },
      ['Y']             = { '<cmd>lua require("drex.actions.text").copy_relative_path()<cr>',
        { desc = 'copy element relative path' } },
      ['<C-y>']         = { '<cmd>lua require("drex.actions.text").copy_absolute_path()<cr>',
        { desc = 'copy element absolute path' } },
    },
    ['v'] = {
      ['d'] = { ':lua require("drex.actions.files").delete("visual")<cr>', { desc = 'delete elements' } },
      ['r'] = { ':lua require("drex.actions.files").multi_rename("visual")<cr>', { desc = 'rename elements' } },
      ['M'] = { ':DrexMark<cr>', { desc = 'mark elements' } },
      ['u'] = { ':DrexUnmark<cr>', { desc = 'unmark elements' } },
      ['m'] = { ':DrexToggle<cr>', { desc = 'toggle elements' } },
      ['y'] = { ':lua require("drex.actions.text").copy_name(true)<cr>', { desc = 'copy element names' } },
      ['Y'] = { ':lua require("drex.actions.text").copy_relative_path(true)<cr>',
        { desc = 'copy element relative paths' } },
      ['<C-y>'] = { ':lua require("drex.actions.text").copy_absolute_path(true)<cr>',
        { desc = 'copy element absolute paths' } },
    }
  }
end

function M.neotree()
  M.nmap {
    { '<M-1>', '<cmd>Neotree action=focus toggle<cr>' },
    { '<M-2>', '<cmd>Neotree action=focus toggle reveal<cr>' },
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
    -- ["<cr>"] = "open_drop",
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
    { '<M-9>', '<cmd>Noice<cr>' }
  }
  M.imap {
    { '<M-9>', '<cmd>Noice<cr>' }
  }
end

function M.lspsaga()
  M.nmap {
    { "<Leader>gg", "<cmd>Lspsaga lsp_finder<cr>" },
    { "<Leader>gh", "<cmd>Lspsaga hover_doc<cr>" },
    { "<Leader>gr", "<cmd>Lspsaga rename<cr>" },
    { "<Leader>gd", "<cmd>Lspsaga peek_definition<cr>" },
    { "<Leader>go", "<cmd>Lspsaga outline<cr>" },
    { "go",         "<cmd>Lspsaga incoming_calls<cr>" },
    { "gO",         "<cmd>Lspsaga outgoing_calls<cr>" },

    -- Diagnostic
    { "<Leader>ge", "<cmd>Lspsaga show_line_diagnostics<cr>" },
    { "gk",         "<cmd>Lspsaga diagnostic_jump_prev<cr>" },
    { "gj",         "<cmd>Lspsaga diagnostic_jump_next<cr>" },
    { "gK", function()
      require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end },
    { "gJ", function()
      require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
    end },

    { "<leader>gt", "<cmd>Lspsaga term_toggle<cr>" },
  }

  M.tmap {
    { "<leader>gt", "<cmd>Lspsaga term_toggle<cr>" },
  }

  M.nvmap {
    { "<Leader>ga", "<cmd>Lspsaga code_action<cr>" },
  }
end

function M.trouble()
  M.nmap {
    { '<M-8>',      '<cmd>TroubleToggle<cr>' },
    { '<leader>xx', '<cmd>TroubleToggle<cr>' },
    { '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>' },
    { '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>' },
    { '<leader>xq', '<cmd>TroubleToggle quickfix<cr>' },
    { '<leader>xl', '<cmd>TroubleToggle loclist<cr>' },
    { '<Leader>xr', '<cmd>TroubleToggle lsp_references<cr>' },
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
    { '<A-j>', ':MoveLine(1)<cr>' },
    { '<A-k>', ':MoveLine(-1)<cr>' },
    { '<A-h>', ':MoveHChar(-1)<cr>' },
    { '<A-l>', ':MoveHChar(1)<cr>' },
  }
  M.vmap {
    { '<A-j>', ':MoveBlock(1)<cr>' },
    { '<A-k>', ':MoveBlock(-1)<cr>' },
    { '<A-h>', ':MoveHBlock(-1)<cr>' },
    { '<A-l>', ':MoveHBlock(1)<cr>' },
  }
end

function M.presistence()
  M.nmap {
    { '<leader>ss', '<cmd>lua require("persistence").load()<cr>' },
    { '<leader>sa', '<cmd>lua require("persistence").load({ last = true })<cr>' },
    { '<leader>sd', '<cmd>lua require("persistence").stop()<cr>' },
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

M.base()

return M
