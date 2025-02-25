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
          function(opts) require('kulala').relay() end,
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
          function(opts) require('kulala').fom_curl() end,
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
        vim.keymap.set({ 'n' }, '[r', '<Cmd>KulalaJumpPrev<CR>', { buffer = true, silent = true })
        vim.keymap.set({ 'n' }, ']r', '<Cmd>KulalaJumpNext<CR>', { buffer = true, silent = true })
        vim.keymap.set({ 'n' }, '<Leader>k', '<Cmd>KulalaOpen<CR>', { buffer = true, silent = true })
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
    cmd = { 'Neogit' },
    opts = {},
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
