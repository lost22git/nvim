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
        local p = [[\v^<(HEAD|GET|POST|PUT|PATCH|DELETE|OPTION)>]]
        local prev = string.format([[<Cmd>call search('%s', 'bw')<CR>]], p)
        local next = string.format([[<Cmd>call search('%s', 'w')<CR>]], p)
        local map = function(...) vim.keymap.set('n', ...) end
        map('[e', prev, { buffer = true, silent = true, desc = '[hurl] Goto prev entry' })
        map(']e', next, { buffer = true, silent = true, desc = '[hurl] Goto next entry' })
        map('<Leader>ee', '<Cmd>HurlRunnerAt<CR>', { buffer = true, silent = true, desc = '[hurl] HurlRunnerAt' })
        map('<Leader>eb', '<Cmd>HurlRunner<CR>', { buffer = true, silent = true, desc = '[hurl] HurlRunner' })
      end
      vim.api.nvim_create_autocmd('FileType', { pattern = 'hurl', callback = create_keymaps })
    end,
  },

  {
    'mistweaverco/kulala.nvim',
    ft = { 'http', 'rest' },
    opts = { winbar = true, show_variable_info_text = 'float' },
    init = function()
      local create_usercmds = function()
        local usercmd = function(...) vim.api.nvim_buf_create_user_command(0, ...) end
        usercmd('KulalaRun', function() require('kulala').run() end, { nargs = 0 })
        usercmd('KulalaRunAll', function() require('kulala').run_all() end, { nargs = 0 })
        usercmd('KulalaToggleView', function() require('kulala').toggle_view() end, { nargs = 0 })
        usercmd('KulalaRelay', function() require('kulala').relay() end, { nargs = 0 })
        usercmd('KulalaOpen', function() require('kulala').open() end, { nargs = 0 })
        usercmd('KulalaInspect', function() require('kulala').inspect() end, { nargs = 0 })
        usercmd('KulalaShowStats', function() require('kulala').show_stats() end, { nargs = 0 })
        usercmd('KulalaCopy', function() require('kulala').copy() end, { nargs = 0 })
        usercmd('KulalaFromCurl', function() require('kulala').from_curl() end, { nargs = 0 })
        usercmd('KulalaSearch', function() require('kulala').search() end, { nargs = 0 })
        usercmd('KulalaJumpPrev', function() require('kulala').jump_prev() end, { nargs = 0 })
        usercmd('KulalaJumpNext', function() require('kulala').jump_next() end, { nargs = 0 })
        usercmd('KulalaClearCachedFiles', function() require('kulala').clear_cached_files() end, { nargs = 0 })
        usercmd('KulalaScratchpad', function() require('kulala').scratchpad() end, { nargs = 0 })
        usercmd(
          'KulalaDownloadGraphqlSchema',
          function() require('kulala').download_graphql_schema() end,
          { nargs = 0 }
        )
        usercmd(
          'KulalaScriptsClearGlobal',
          function(o) require('kulala').scripts_clear_global(unpack(o.fargs)) end,
          { nargs = '*' }
        )
      end
      local create_keymaps = function()
        local map = function(...) vim.keymap.set({ 'n' }, ...) end
        map('<Leader>E', '<Cmd>KulalaSearch<CR>', { buffer = true, silent = true, desc = '[kulala] KulalaSearch' })
        map('<Leader>ee', '<Cmd>KulalaRun<CR>', { buffer = true, silent = true, desc = '[kulala] KulalaRun' })
        map('<Leader>eb', '<Cmd>KulalaRunAll<CR>', { buffer = true, silent = true, desc = '[kulala] KulalaRunAll' })
        map('[e', '<Cmd>KulalaJumpPrev<CR>', { buffer = true, silent = true, desc = '[kulala] KulalaJumpPrev' })
        map(']e', '<Cmd>KulalaJumpNext<CR>', { buffer = true, silent = true, desc = '[kulala] KualalaJumpNext' })
        map('<Leader>ls', '<Cmd>KulalaOpen<CR>', { buffer = true, silent = true, desc = '[kulala] KulalaOpen' })
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
}
