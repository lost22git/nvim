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

  -- Nvim web devicons
  {
    'nvim-tree/nvim-web-devicons',
  },

  -- Zen Mode
  { "folke/zen-mode.nvim", module = "zen-mode", cmd = { "ZenMode" } },

  -- UI
  { "MunifTanjim/nui.nvim" },

  -- 快速 ESC
  {
    'TheBlob42/houdini.nvim',
    event = { "InsertEnter", "CmdLineEnter", "TermEnter" },
    config = function()
      require('houdini').setup()
    end
  },

  -- 缩进
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local scope_highlight = {
        "RainbowBlue",
      }
      local indent_highlight = {
        "RainbowViolet",
      }

      local hooks = require "ibl.hooks"
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        -- vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        -- vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        -- vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        -- vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        -- vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      require("ibl").setup {
        scope = { highlight = scope_highlight },
        indent = { char = '╎', highlight = indent_highlight },
      }
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
      require('move').setup {}
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
      require("nvim-surround").setup()
    end
  },

  -- split and join
  {
    'Wansmer/treesj',
    keys = { '<leader>j' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup {
        -- Use default keymaps
        -- (<space>m - toggle, <space>j - join, <space>s - split)
        use_default_keymaps = false,

        -- Node with syntax error will not be formatted
        check_syntax_error = true,

        -- If line after join will be longer than max value,
        -- node will not be formatted
        max_join_length = 120,

        -- hold|start|end:
        -- hold - cursor follows the node/place on which it was called
        -- start - cursor jumps to the first symbol of the node being formatted
        -- end - cursor jumps to the last symbol of the node being formatted
        cursor_behavior = 'hold',

        -- Notify about possible problems or not
        notify = true,
        langs = {},

        -- Use `dot` for repeat action
        dot_repeat = true,
      }

      require('core.maps').treesj()
    end
  },

  -- TODO
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require("todo-comments").setup {}
      require('core.maps').todo()
    end
  },

  -- 大纲 outline
  {
    "hedyhli/outline.nvim",
    keys = { '<leader>go' },
    config = function()
      require("outline").setup {}
      require('core.maps').outline()
    end
  },
}
