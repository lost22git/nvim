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

  -- True Zen
  {
    -- "Pocco81/true-zen.nvim",
    "ilan-schemoul/true-zen.nvim",
    enabled = not vim.g.vscode,
    branch = "fix-restore-value",
    cmd = { 'TZNarrow', 'TZFocus', 'TZMinimalist', 'TZAtaraxis' },
    config = function()
      require("true-zen").setup {}
    end,
  },

  -- UI
  { "MunifTanjim/nui.nvim" },

  -- 快速 ESC
  {
    'TheBlob42/houdini.nvim',
    event = { "InsertEnter", "CmdLineEnter", "TermEnter" },
    config = function()
      require('houdini').setup {
        escape_sequences = {
          ['v'] = false,
          ['V'] = false,
        }
      }
    end
  },

  -- 缩进
  -- {
  --   'lukas-reineke/indent-blankline.nvim',
  --   event = { "BufReadPost", "BufNewFile" },
  --   config = function()
  --     local scope_highlight = {
  --       "RainbowBlue",
  --     }
  --     local indent_highlight = {
  --       "RainbowViolet",
  --     }
  --
  --     local hooks = require "ibl.hooks"
  --     -- create the highlight groups in the highlight setup hook, so they are reset
  --     -- every time the colorscheme changes
  --     hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  --       -- vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
  --       -- vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
  --       vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
  --       -- vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
  --       -- vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
  --       vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
  --       -- vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
  --     end)
  --
  --     require("ibl").setup {
  --       scope = { highlight = scope_highlight },
  --       indent = { char = '╎', highlight = indent_highlight },
  --     }
  --   end
  -- },

  -- 颜色代码高亮
  {
    'NvChad/nvim-colorizer.lua',
    cmd = { "ColorizerAttachToBuffer" },
    config = function()
      require("colorizer").setup {
        user_default_options = {
          tailwind    = true,
          mode        = "virtualtext",
          virtualtext = "■",
        }
      }
    end
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
    enabled = not vim.g.vscode,
    cmd = { 'Trouble' },
    keys = { '<M-8>', 'gee', 'ged', 'ger', 'geq', 'gel' },
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
    enabled = not vim.g.vscode,
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
    enabled = not vim.g.vscode,
    keys = { ';' },
    config = function()
      require('neo-zoom').setup {
        popup = { enabled = true }, -- this is the default.
        exclude_buftypes = { 'terminal' },
        -- exclude_filetypes = { 'lspinfo', 'mason', 'lazy', 'fzf', 'qf' },
        winopts = {
          offset = {
            -- NOTE: omit `top`/`left` to center the floating window vertically/horizontally.
            -- top = 0,
            -- left = 0.17,
            width = 150,
            height = 0.85,
          },
          -- NOTE: check :help nvim_open_win() for possible border values.
          border = 'rounded',
        },
        presets = {
          {
            -- NOTE: regex pattern can be used here!
            filetypes = { 'dapui_.*', 'dap-repl' },
            winopts = {
              offset = { top = 0.02, left = 0.26, width = 0.74, height = 0.25 },
            },
          },
          {
            filetypes = { 'markdown' },
            callbacks = {
              function() vim.wo.wrap = true end,
            },
          },
        },
      }

      vim.keymap.set('n', ';', function() vim.cmd('NeoZoomToggle') end, { silent = true, nowait = true })

      vim.api.nvim_create_autocmd({ 'WinEnter' }, {
        callback = function()
          local zoom_book = require('neo-zoom').zoom_book

          if require('neo-zoom').is_neo_zoom_float()
          then
            for z, _ in pairs(zoom_book) do vim.wo[z].winbl = 0 end
          else
            for z, _ in pairs(zoom_book) do vim.wo[z].winbl = 20 end
          end
        end
      })
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
    enabled = not vim.g.vscode,
    keys = { '<leader>go' },
    config = function()
      require("outline").setup {}
      require('core.maps').outline()
    end
  },

  -- markdown better previewer
  -- {
  --   'MeanderingProgrammer/markdown.nvim',
  --   name = 'render-markdown',
  --   ft = 'markdown',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --   config = function()
  --     require('render-markdown').setup {}
  --   end,
  -- },

  -- {
  --   "OXY2DEV/markview.nvim",
  --   enabled = not vim.g.vscode,
  --   ft = 'markdown',
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons", -- Used by the code bloxks
  --   },
  --   config = function()
  --     require("markview").setup {}
  --   end
  -- },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = not vim.g.vscode,
    ft = 'markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
    opts = {},
  },

  {
    'Kicamon/markdown-table-mode.nvim',
    ft = 'markdown',
    config = function()
      require('markdown-table-mode').setup()
    end
  },

  -- 窗口动画
  -- {
  --   'tamton-aquib/flirt.nvim',
  --   lazy = false,
  --   config = function()
  --     require("flirt").setup {
  --       override_open = true,                          -- experimental
  --       close_command = 'Q',
  --       default_move_mappings = true,                  -- <C-arrows> to move floats
  --       default_resize_mappings = true,                -- <A-arrows> to resize floats
  --       default_mouse_mappings = true,                 -- Drag floats with mouse
  --       exclude_fts = { 'notify', 'cmp_menu' },
  --       speed = 100,                                    -- Can vary from 1 to 100 (100 is fast)
  --       custom_filter = function(buffer, win_config)
  --         return vim.bo[buffer].filetype == 'cmp_menu' -- avoids animation
  --       end
  --     }
  --   end
  -- }
  --

  -- HURL
  {
    "jellydn/hurl.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter"
    },
    ft = "hurl",
    opts = {
      debug = false,
      show_notification = false,
      mode = "split",
      formatters = {
        json = { 'jq' },
        html = {
          'prettier',
          '--parser',
          'html',
        },
      },
    },
  },

  -- border global settings
  {
    'mikesmithgh/borderline.nvim',
    event = 'VeryLazy',
    config = function()
      require('borderline').setup {}
      require('borderline.api').borderline('solid')
    end,
  }

}
