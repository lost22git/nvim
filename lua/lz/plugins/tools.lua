return {

  ----------
  -- Hurl --
  ----------

  {
    'jellydn/hurl.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = 'hurl',
    opts = {
      debug = false,
      show_notification = false,
      mode = 'split',
      formatters = {
        json = { 'jq' },
        html = {
          'prettier',
          '--parser',
          'html',
        },
      },
    },
    init = function()
      local create_keymaps = function()
        vim.keymap.set(
          { 'n' },
          '[e',
          [[<Cmd>call search('\v^<(HEAD|GET|POST|PUT|PATCH|DELETE|OPTION)>', 'bw')<CR>]],
          { buffer = true, silent = true, desc = 'Hurl goto prev entry' }
        )
        vim.keymap.set(
          { 'n' },
          ']e',
          [[<Cmd>call search('\v^<(HEAD|GET|POST|PUT|PATCH|DELETE|OPTION)>', 'w')<CR>]],
          { buffer = true, silent = true, desc = 'Hurl goto next entry' }
        )
        vim.keymap.set(
          { 'n' },
          '<Leader>ee',
          '<Cmd>HurlRunnerAt<CR>',
          { buffer = true, silent = true, desc = 'HurlRunnerAt' }
        )
        vim.keymap.set(
          { 'n' },
          '<Leader>eb',
          '<Cmd>HurlRunner<CR>',
          { buffer = true, silent = true, desc = 'HurlRunner' }
        )
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'hurl',
        callback = function() create_keymaps() end,
      })
    end,
  },

  ------------
  -- kulala --
  ------------

  {
    'mistweaverco/kulala.nvim',
    ft = { 'http' },
    opts = {
      winbar = true,
      show_variable_info_text = 'float',
    },
    config = function(_, opts)
      require('kulala').setup(opts)

      local create_usercmds = function()
        vim.api.nvim_buf_create_user_command(0, 'KulalaRun', function(opts) require('kulala').run() end, { nargs = 0 })
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaRunAll',
          function(opts) require('kulala').run_all() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaToggleView',
          function(opts) require('kulala').toggle_view() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaRelay',
          function(_opts) require('kulala').relay() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaOpen',
          function(opts) require('kulala').open() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaInspect',
          function(opts) require('kulala').inspect() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaShowStats',
          function(opts) require('kulala').show_stats() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaCopy',
          function(opts) require('kulala').copy() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaFromCurl',
          function(opts) require('kulala').from_curl() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaSearch',
          function(opts) require('kulala').search() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaJumpPrev',
          function(opts) require('kulala').jump_prev() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaJumpNext',
          function(opts) require('kulala').jump_next() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaScriptsClearGlobal',
          function(opts) require('kulala').scripts_clear_global(unpack(opts.fargs)) end,
          { nargs = '*' }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaClearCachedFiles',
          function(opts) require('kulala').clear_cached_files() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaScratchpad',
          function(opts) require('kulala').scratchpad() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaDownloadGraphqlSchema',
          function(opts) require('kulala').download_graphql_schema() end,
          { nargs = 0 }
        )
      end

      local create_keymaps = function()
        vim.keymap.set(
          { 'n' },
          '<Leader>E',
          '<Cmd>KulalaSearch<CR>',
          { buffer = true, silent = true, desc = 'KulalaSearch' }
        )
        vim.keymap.set(
          { 'n' },
          '<Leader>ee',
          '<Cmd>KulalaRun<CR>',
          { buffer = true, silent = true, desc = 'KulalaRun' }
        )
        vim.keymap.set(
          { 'n' },
          '<Leader>eb',
          '<Cmd>KulalaRunAll<CR>',
          { buffer = true, silent = true, desc = 'KulalaRunAll' }
        )
        vim.keymap.set(
          { 'n' },
          '[e',
          '<Cmd>KulalaJumpPrev<CR>',
          { buffer = true, silent = true, desc = 'KulalaJumpPrev' }
        )
        vim.keymap.set(
          { 'n' },
          ']e',
          '<Cmd>KulalaJumpNext<CR>',
          { buffer = true, silent = true, desc = 'KualalaJumpNext' }
        )
        vim.keymap.set(
          { 'n' },
          '<Leader>ls',
          '<Cmd>KulalaOpen<CR>',
          { buffer = true, silent = true, desc = 'KulalaOpen' }
        )
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'http',
        callback = function()
          create_usercmds()
          create_keymaps()
        end,
      })
    end,
  },

  ------------
  -- neogit --
  ------------

  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- "sindrets/diffview.nvim",
    },
    cmd = { 'Neogit', 'NeogitCommit' },
    opts = {},
  },

  --------------
  -- fugitive --
  --------------

  {
    'tpope/vim-fugitive',
    cmd = 'Git',
  },

  --------------
  -- gitsigns --
  --------------

  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      on_attach = function(_bufnr) require('core.maps').gitsigns() end,
      numhl = true,
    },
  },
}
