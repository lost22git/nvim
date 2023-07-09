return {
  -- 启动时间统计
  {
    "dstein64/vim-startuptime",
    enabled = true,
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Zen Mode
  { "folke/zen-mode.nvim", module = "zen-mode", cmd = { "ZenMode" } },

  -- UI
  { "MunifTanjim/nui.nvim" },

  -- 通知
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup {
        background_colour = "#000000",
        top_down = true,
        stages = 'fade',
      }
    end
  },

  -- 快速 ESC
  {
    'TheBlob42/houdini.nvim',
    event = { "InsertEnter", "CmdLineEnter", "TermEnter" },
    config = function()
      require('houdini').setup()
    end
  },

  -- 注释
  {
    'numToStr/Comment.nvim',
    keys = { 'gcc', { 'gc', mode = 'v' } },
    config = function()
      require('Comment').setup()
    end
  },

  -- Nvim web devicons
  {
    'nvim-tree/nvim-web-devicons',
  },

  -- 颜色代码高亮
  {
    'norcalli/nvim-colorizer.lua',
    cmd = { "ColorizerAttachToBuffer" },
  },

  -- 增量重命名
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = function()
      require("inc_rename").setup {}
    end,
  },

  -- 自动补全括号
  {
    "windwp/nvim-autopairs",
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function()
      require('nvim-autopairs').setup {
        disable_filetype = { "TelescopePrompt", "vim" },
      }
    end
  },

  -- 自动补全括号
  {
    "hrsh7th/nvim-insx",
    event = { 'InsertEnter' },
    config = function()
      require('insx.preset.standard').setup {}
    end
  },

  -- 移动行/块
  {
    'fedepujol/move.nvim',
    keys = { '<M-j>', '<M-k>', '<M-l>', '<M-h>' },
    config = function()
      require('core.maps').move()
    end
  },

  -- 可视区域内跳转
  {
    "folke/flash.nvim",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  -- 错误列表
  {
    "folke/trouble.nvim",
    cmd = { 'Trouble' },
    keys = { '<M-8>', '<leader>xx', '<Leader>xd', '<Leader>xr' },
    config = function()
      local trouble = require('trouble')
      trouble.setup {
      }
      require('core.maps').trouble()
    end
  },

  -- Rust crate
  {
    'saecki/crates.nvim',
    event = { "BufRead Cargo.toml" },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup()
    end,
  },

  -- Textobject selection
  {
    'echasnovski/mini.ai',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('mini.ai').setup()
    end,
  },

  -- Session
  {
    "folke/persistence.nvim",
    keys = { '<leader>ss', '<leader>sa', '<leader>sd' },
    config = function()
      require("persistence").setup()
      require('core.maps').presistence()
    end,
  },

  -- 保护颈椎
  {
    'nyngwang/NeoZoom.lua',
    keys = { ';' },
    config = function()
      require('neo-zoom').setup {
        -- top_ratio = 0,
        -- left_ratio = 0.225,
        -- width_ratio = 0.775,
        -- height_ratio = 0.925,
        border = 'rounded',
        -- disable_by_cursor = true, -- zoom-out/unfocus when you click anywhere else.
        -- exclude_filetypes = { 'lspinfo', 'mason', 'lazy', 'fzf', 'qf' },
        exclude_buftypes = { 'terminal' },
        -- popup = {
        --   -- NOTE: Add popup-effect (replace the window on-zoom with a `[No Name]`).
        --   -- This way you won't see two windows of the same buffer
        --   -- got updated at the same time.
        --   enabled = true,
        --   exclude_filetypes = {},
        --   exclude_buftypes = {},
        -- },
      }
      vim.keymap.set('n', ';', function() vim.cmd('NeoZoomToggle') end, { silent = true, nowait = true })
    end
  },
  -- surround
  {
    "kylechui/nvim-surround",
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require("nvim-surround").setup {}
    end
  },
}
