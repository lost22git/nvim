return {
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
        html = { 'prettier', '--parser', 'html' },
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
        vim.api.nvim_buf_create_user_command(0, 'KulalaRun', function() require('kulala').run() end, { nargs = 0 })
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaRunAll',
          function() require('kulala').run_all() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaToggleView',
          function() require('kulala').toggle_view() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(0, 'KulalaRelay', function() require('kulala').relay() end, { nargs = 0 })
        vim.api.nvim_buf_create_user_command(0, 'KulalaOpen', function() require('kulala').open() end, { nargs = 0 })
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaInspect',
          function() require('kulala').inspect() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaShowStats',
          function() require('kulala').show_stats() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(0, 'KulalaCopy', function() require('kulala').copy() end, { nargs = 0 })
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaFromCurl',
          function() require('kulala').from_curl() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaSearch',
          function() require('kulala').search() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaJumpPrev',
          function() require('kulala').jump_prev() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaJumpNext',
          function() require('kulala').jump_next() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaScriptsClearGlobal',
          function() require('kulala').scripts_clear_global(unpack(opts.fargs)) end,
          { nargs = '*' }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaClearCachedFiles',
          function() require('kulala').clear_cached_files() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaScratchpad',
          function() require('kulala').scratchpad() end,
          { nargs = 0 }
        )
        vim.api.nvim_buf_create_user_command(
          0,
          'KulalaDownloadGraphqlSchema',
          function() require('kulala').download_graphql_schema() end,
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

  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- "sindrets/diffview.nvim",
    },
    cmd = { 'Neogit', 'NeogitCommit' },
    opts = {},
  },

  {
    'tpope/vim-fugitive',
    cmd = 'Git',
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      on_attach = function() require('core.maps').gitsigns() end,
      numhl = true,
    },
  },

  {
    'skywind3000/asyncrun.vim',
    lazy = false,
    cmd = { 'AsyncRun', 'AsyncRunVisual' },
    config = function()
      vim.g.asyncrun_bell = 10
      -- AsyncRunVisual
      vim.api.nvim_create_user_command('AsyncRunVisual', function(opts)
        -- get selection_text in visual mode
        vim.cmd('normal! gv"xy')
        local selection_text = vim.fn.getreg('x')
        selection_text = vim.fn.trim(selection_text)

        -- write selection_text into tempfile
        local f = vim.fs.dirname(os.tmpname()) .. '/asyncrunvisual.tmp'
        vim.fn.writefile(vim.split(selection_text, '\n'), f)

        -- ensure tempfile accessible
        if vim.fn.has('unix') then os.execute('chmod 777 ' .. f) end

        -- call asyncrun
        vim.cmd('AsyncRun ' .. opts.args .. ' ' .. f)
      end, { nargs = '+', range = true })
    end,
  },
}
