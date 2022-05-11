vim.cmd('syntax on')

vim.cmd [[
  set autoindent
  set expandtab
  set shiftwidth=2
  set smartindent
  set softtabstop=2
  set tabstop=2
  language en_US.utf8
]]
-- autocmd --
-- see :help guicursor
-- Set the style of the guicursor after leaving nvim
vim.cmd("autocmd VimLeave * set guicursor=a:hor20-blinkwait700-blinkoff400-blinkon250")

-- variables --
local vars = {
  mapleader = ' ',
  auto_save = 0
}
for k, v in pairs(vars) do
  vim.api.nvim_set_var(k, v)
end

-- options --
local options = {
  encoding = 'utf-8',
  fileencoding = 'utf-8',
  fileencodings = 'utf-8',
  -- search
  incsearch = true,
  hlsearch = true,
  ignorecase = true,
  smartcase = true,
  -- display
  ruler = true,
  mouse = 'a',
  -- misc
  hidden = true,
  -- virtualedit = 'all',
  backspace = 'indent,eol,start',
  -- :help shell-powershell
  shell = 'pwsh.exe',
  shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;',
  shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode',
  shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode',
  shellquote = '',
  shellxquote = ''
}
local win_options = {
  cursorline = true,
  number = true,
  relativenumber = true,
  numberwidth = 2
}
local buf_options = {
}
for k, v in pairs(options) do
  vim.api.nvim_set_option(k, v)
end
for k, v in pairs(win_options) do
  vim.api.nvim_win_set_option(0, k, v)
end
for k, v in pairs(buf_options) do
  vim.api.nvim_buf_set_option(0, k, v)
end

-- keymaps --
vim.cmd [[
  vnoremap < <gv
  vnoremap > >gv
  nnoremap qq <cmd>q<cr>
  nnoremap Q <cmd>q!<cr>
  nnoremap <c-s> <cmd>w<cr>
  noremap J }
  noremap K {
  noremap H ^
  noremap L $
  inoremap <c-m> <esc>o
  nnoremap <c-a> <esc>^v$
  noremap <a-a> <esc>ggvG
  noremap <leader>n <cmd>set nu!<cr>
  vnoremap <c-C> "+y
  inoremap <c-z> <esc>ui
  noremap <c-z> u
]]

-- local keymaps = { --
--   { '', 'qq', '<cmd>q<cr>' }, --
--   { '', 'Q', '<cmd>q!<cr>' }, --
--   { '', '<C-s>', '<cmd>w<cr>' }, --
--   { '', 'H', '^' }, --
--   { '', 'L', '$' }, --
--   { 'i', '<C-M>', '<Esc>o' }, --
--   { '', '<C-a>', '<Esc>^v$' }, --
--   { '', '<A-a>', '<Esc>ggvG' }, --
--   { 'n', '<leader>n', '<Cmd>set nu!<CR>' } --
--   -- use transparent background from terminal
--   --{'n','<A-t>', '<cmd>highlight Normal ctermbg=NONE guibg=NONE<cr>'} --
-- }
--
-- for _, km in pairs(keymaps) do
--   local opts = {
--     noremap = true,
--     silent = true
--   }
--   if km[4] ~= nil then
--     opts = km[4]
--   end
--   vim.api.nvim_set_keymap(km[1], km[2], km[3], opts)
-- end

-------------------------------------------------------------------------
-- plugin & plugin config
-------------------------------------------------------------------------
-- packer install if not exists --
local packer_install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
  packer_bootstrap = vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_install_path })
end
-- config packer --
vim.cmd('packadd packer.nvim')
local packer = require('packer')
packer.startup({
  function(use)
    use 'wbthomason/packer.nvim'
    use 'ellisonleao/gruvbox.nvim'
    use 'projekt0n/github-nvim-theme'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-lua/popup.nvim'
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
    }
    use 'folke/which-key.nvim'

    -- nvim-cmp for completion
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use {
      'saecki/crates.nvim',
      event = { "BufRead Cargo.toml" },
      requires = { { 'nvim-lua/plenary.nvim' } },
      config = function()
        require('crates').setup()
      end,
    }
    -- telescope for fuzzy find
    use {
      'nvim-telescope/telescope.nvim',
      requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { 'nvim-telescope/telescope-packer.nvim' }
    use { 'nvim-telescope/telescope-file-browser.nvim' }
    use { 'nvim-telescope/telescope-ui-select.nvim' }
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make'
    } -- use {'nvim-telescope/telescope-media-files.nvim'} -- only linux

    -- nvim-autopairs for bracket
    use { 'windwp/nvim-autopairs' }

    -- lualine for status bar
    use {
      'nvim-lualine/lualine.nvim',
      requires = {
        'kyazdani42/nvim-web-devicons',
        opt = true
      }
    }
    -- bufferline for tabs
    use {
      'akinsho/bufferline.nvim',
      requires = 'kyazdani42/nvim-web-devicons'
    }
    -- nvim-tree for file explorer
    use {
      'kyazdani42/nvim-tree.lua',
      requires = { 'kyazdani42/nvim-web-devicons' }
    }

    -- trouble.nvim for diagnostics --
    use {
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
    }

    -- lsp-format for formatting
    use 'lukas-reineke/lsp-format.nvim'
    -- lsp
    use { 'neovim/nvim-lspconfig' }
    use { 'williamboman/nvim-lsp-installer' }
    -- dap
    use { 'mfussenegger/nvim-dap' }
    -- toggleterm for terminal
    use { 'akinsho/toggleterm.nvim' }
    -- rust-tools for rust
    use { 'simrat39/rust-tools.nvim' }

    if packer_bootstrap then
      packer.sync()
    end
  end,
  config = {
    display = {
      open_fn = require('packer.util').float
    }
  }
})


-- config gruvbox theme --
vim.o.termguicolors = true
vim.o.background = 'dark'
vim.cmd('colorscheme gruvbox')

-- config github theme --
require('github-theme').setup {
  theme_style = "dark",
}

-- config treesitter --
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'rust', 'lua', 'java' },
  sync_install = true,
  ignore_install = {},

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      node_decremental = '<BS>'
    }
  },
  indent = {
    enable = true
  }
}

-- config which-key
require('which-key').setup {}

-- config auto-pairs --
require('nvim-autopairs').setup {}

-- config nvim-cmp --
vim.g.completeopt = 'menu, menuone, noselect, noinsert'
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
-- config nvim-cmp.
local cmp = require('cmp')
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end
  },
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close()
    }),
    ['<CR>'] = cmp.mapping.confirm({
      select = true
    }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' }
  })
})
-- Set configuration for specific filetype.
cmp.setup.filetype("toml", {
  sources = cmp.config.sources({
    { name = "crates" }
  })
})
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({ {
    name = 'cmp_git'
  } -- You can specify the `cmp_git` source if you were installed it.
  }, { {
    name = 'buffer'
  } })
})
-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = { {
    name = 'buffer'
  } }
})
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({ {
    name = 'path'
  } }, { {
    name = 'cmdline'
  } })
})

-- config lspconfig.
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp_installer = require("nvim-lsp-installer")
--require("lsp-format").setup {}
lsp_installer.on_server_ready(function(server)
  -- skip rust-analyzer
  if server.name == 'rust-analyer' then
    return
  end

  local opts = {
    capabilities = capabilities,
    -- lsp-format
    on_attach = require("lsp-format").on_attach
  }
  if server.name == 'sumneko_lua' then
    opts.settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  end

  server:setup(opts)
end)
-- config rust-analyzer
local on_attach = function(client)
  require('completion').on_attach(client)
end
lspconfig['rust_analyzer'].setup {
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = 'module',
        importPrefix = 'by_sel'
      },
      cargo = {
        loadOutDirsFromCheck = true
      },
      procMacro = {
        enable = true
      }
    }
  }
}

-- config rust-tools --
local rust_tools = require('rust-tools')
local extension_path = 'E:/_config/vscode/data/extensions/vadimcn.vscode-lldb-1.7.0/'
local codelldb_path = extension_path .. 'adapter/codelldb.exe'
local liblldb_path = extension_path .. 'lldb/bin/liblldb.dll'
rust_tools.setup {
  tools = {
    hover_actions = {
      auto_focus = true
    }
  },
  server = {
    -- standalone file support
    -- setting it to false may improve startup time
    standalone = false,
    settings = {
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ['rust-analyzer'] = {
        checkOnSave = {
          command = "check",
          overrideCommand = { "cargo", "clippy", "--fix", "--workspace", "--message-format=json", "--all-targets", "--allow-dirty" }
        }
      }
    }
  }, -- rust-analyer options
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
  }
}

-- config toggleterm
vim.cmd [[
    noremap <silent><leader>vh <cmd>ToggleTerm dir=. direction=horizontal<cr>
    noremap <silent><leader>vv <cmd>ToggleTerm dir=. direction=vertical<cr>
    noremap <silent><leader>vf <cmd>ToggleTerm dir=. direction=float<cr>
]]
require("toggleterm").setup {
  -- size can be a number or function which is passed the current terminal
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = '<A-2>',
  -- on_open = fun(t: Terminal), -- function to run when the terminal opens
  -- on_close = fun(t: Terminal), -- function to run when the terminal closes
  -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
  -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
  -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  -- shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  direction = 'float', -- 'vertical' | 'horizontal' | 'window' | 'float',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'curved', -- 'single' | 'double' | 'shadow' | 'curved',
    --   width = <value>,
    --   height = <value>,
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal"
    }
  }
}

-- config lualine --
require('lualine').setup {
  options = {
    section_separators = '',
    component_separators = ''
  }
}
-- config bufferline --
vim.opt.termguicolors = true
vim.cmd [[
    nnoremap <silent><TAB> <cmd>BufferLineCycleNext<cr>
    nnoremap <silent><S-TAB> <cmd>BufferLineCyclePrev<cr>
]]
require('bufferline').setup {
  options = {
    left_mouse_command = 'buffer %d',
    right_mouse_command = nil,
    middle_mouse_command = 'bdelete! %d',
    show_buffer_close_icons = false,
    show_close_icon = false
  }
}
-- config NvimTree --
vim.cmd [[
    noremap <silent><A-1> <cmd>NvimTreeToggle<cr>
]]
require('nvim-tree').setup {}

-- config trouble.nvim --
vim.cmd [[
  nnoremap <leader>xx <cmd>TroubleToggle<cr>
  nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
  nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
  nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
  nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
  nnoremap gR <cmd>TroubleToggle lsp_references<cr>
]]
-- config telescope --
vim.cmd [[
  nnoremap <silent><leader>tf <cmd>lua require('telescope.builtin').find_files()<cr>
  nnoremap <silent><leader>ti <cmd>lua require('telescope.builtin').git_files()<cr>
  nnoremap <silent><leader>tg <cmd>lua require('telescope.builtin').live_grep()<cr>
  nnoremap <silent><leader>tb <cmd>lua require('telescope.builtin').buffers()<cr>
  nnoremap <silent><leader>tp <cmd>lua require('telescope.builtin').builtin()<cr>
  nnoremap <silent><leader>th <cmd>lua require('telescope.builtin').help_tags()<cr>
  nnoremap <silent><leader>tR <cmd>lua require('telescope.builtin').reloader()<cr>
  nnoremap <silent><leader>tc <cmd>lua require('telescope.builtin').commands()<cr>
  nnoremap <silent><leader>tr <cmd>lua require('telescope.builtin').command_history()<cr>
  nnoremap <silent><leader>tt <cmd>lua require('telescope').extensions.file_browser.file_browser()<cr>
]]
local telescope = require('telescope')
--  trouble.nvim integrate to telescope
local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")
telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<C-h>'] = 'which_key',
        -- TODO not work
        ['C-b>'] = trouble.open_with_trouble
      },
      -- TOOD not work
      n = {
        ['<C-b>'] = trouble.open_with_trouble
      },
    }
  },
  pickers = {},
  extensions = {
    packer = {
      layout_config = {
        height = .5
      }
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case' -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
    },
    file_browser = {
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        }
      }
    },
    ['ui-select'] = { require('telescope.themes').get_dropdown {
      -- even more opts
    } }
    -- media_files = {
    --     -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
    --     filetypes = {'png', 'webp', 'jpg', 'jpeg'},
    --     find_cmd = 'rg' -- find command (defaults to `fd`)
    -- }
  }
}
telescope.load_extension('packer')
telescope.load_extension('file_browser')
telescope.load_extension('ui-select')
telescope.load_extension('fzf')
-- telescope.load_extension 'media_files'
