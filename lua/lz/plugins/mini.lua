local raku_comment_block = function(ai_type, _, _)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local title_start_lines, res = {}, {}

  local process_line = function(i, l)
    local start_title = l:match('^=begin (.*)$')
    if start_title ~= nil then
      title_start_lines[start_title] = i
      return
    end

    local end_title = l:match('^=end (.*)$')
    if end_title == nil or title_start_lines[end_title] == nil then return end

    local from_line = title_start_lines[end_title] + (ai_type == 'i' and 1 or 0)
    local to_line = i - (ai_type == 'i' and 1 or 0)
    title_start_lines[end_title] = nil

    if from_line >= to_line then return end
    local to_col = ai_type == 'i' and vim.fn.getline(to_line):len() or l:len()
    local from, to = { line = from_line, col = 1 }, { line = to_line, col = to_col }
    table.insert(res, { from = from, to = to, vis_mode = 'V' })
  end

  for i, l in ipairs(lines) do
    process_line(i, l)
  end

  return res
end

local comment_block = function(...)
  local ft = vim.bo.filetype
  if ft == 'raku' then
    return raku_comment_block(...)
  else
    return
  end
end

return {
  {
    'echasnovski/mini.icons',
    lazy = false,
    config = function()
      require('mini.icons').setup({})
      MiniIcons.mock_nvim_web_devicons()
    end,
  },

  {
    'echasnovski/mini.cursorword',
    event = { 'BufNewFile', 'BufReadPost' },
    opts = {},
  },

  {
    'echasnovski/mini.move',
    keys = {
      { '<M-j>', mode = { 'n', 'v' }, desc = '[mini.move] Down' },
      { '<M-k>', mode = { 'n', 'v' }, desc = '[mini.move] Up' },
      { '<M-l>', mode = { 'n', 'v' }, desc = '[mini.move] Right' },
      { '<M-h>', mode = { 'n', 'v' }, desc = '[mini.move] Left' },
    },
    opts = {},
  },

  {
    'echasnovski/mini.hipatterns',
    lazy = false,
    config = function()
      require('mini.hipatterns').setup({
        highlighters = {
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

          warn = { pattern = '%f[%w]()WARN()%f[%W]', group = 'MiniHipatternsHack' },
          warning = { pattern = '%f[%w]()WARNING()%f[%W]', group = 'MiniHipatternsHack' },
          err = { pattern = '%f[%w]()ERR()%f[%W]', group = 'MiniHipatternsFixme' },
          error = { pattern = '%f[%w]()ERROR()%f[%W]', group = 'MiniHipatternsFixme' },
        },
      })
    end,
  },

  {
    'echasnovski/mini.statusline',
    lazy = false,
    opts = {
      use_icons = true,
      set_vim_settings = true,
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local diff = MiniStatusline.section_diff({ trunc_width = 75 })
          local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local location = MiniStatusline.section_location({ trunc_width = 75 })
          local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

          -- show buffer count
          local buffers = '󱂬 ' .. require('core.utils').get_buffer_count()

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { buffers, fileinfo } },
            { hl = mode_hl, strings = { search, location } },
          })
        end,
      },
    },
    config = function(_, opts)
      require('mini.statusline').setup(opts)
      local reset_hls = function() vim.cmd([[hi! link MiniStatuslineModeNormal StatusLine]]) end
      vim.api.nvim_create_autocmd('ColorScheme', { callback = reset_hls })
      reset_hls()
    end,
  },

  {
    'echasnovski/mini.files',
    keys = {
      { '<M-1>', function() MiniFiles.open() end, desc = '[mini.files] Open' },
      {
        '<M-2>',
        function() MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end,
        desc = '[mini.files] Open current directory',
      },
    },
    opts = {
      -- Use `''` (empty string) to not create one.
      mappings = {
        close = 'q',
        go_in = 'l',
        go_in_plus = 'L',
        go_out = 'h',
        go_out_plus = 'H',
        reset = '<BS>',
        show_help = 'g?',
        synchronize = '=',
        trim_left = '<',
        trim_right = '>',
      },
      options = {
        permanent_delete = true,
        use_as_default_explorer = true,
      },
      windows = {
        max_number = math.huge,
        preview = true,
        width_focus = 50,
        width_nofocus = 15,
        width_preview = 25,
      },
    },
    config = function(_, opts)
      require('mini.files').setup(opts)

      local yank_full_path = function()
        local path = MiniFiles.get_fs_entry().path
        vim.fn.setreg('+', path)
        -- Print path yanked
        print(path)
      end
      local yank_relative_path = function()
        local path = MiniFiles.get_fs_entry().path
        vim.fn.setreg('+', vim.fn.fnamemodify(path, ':.'))
        -- Print path yanked
        print(vim.fn.fnamemodify(path, ':.'))
      end
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          vim.keymap.set('n', 'gy', yank_full_path, { buffer = args.data.buf_id })
          vim.keymap.set('n', 'gY', yank_relative_path, { buffer = args.data.buf_id })
        end,
      })
    end,
  },

  {
    'echasnovski/mini.pick',
    dependencies = { { 'echasnovski/mini.extra', opts = {} } },
    cmd = { 'Pick' },
    keys = { '<Leader>f' },
    opts = {
      mappings = {
        scroll_down = '<C-j>',
        scroll_left = '<C-h>',
        scroll_right = '<C-l>',
        scroll_up = '<C-k>',
        move_down = '<M-j>',
        move_up = '<M-k>',
        caret_left = '<C-b>',
        caret_right = '<C-f>',
        delete_char_right = '<C-d>',
      },
    },
    config = function(_, opts)
      require('mini.pick').setup(opts)
      require('core.maps').mini_pick()
    end,
  },

  {
    'echasnovski/mini.ai',
    dependencies = { { 'echasnovski/mini.extra', opts = {} } },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('mini.ai').setup({
        mappings = {
          -- Main textobject prefixes
          around = 'a',
          inside = 'i',

          -- Next/last textobjects
          around_next = 'an',
          inside_next = 'in',
          around_last = 'al',
          inside_last = 'il',

          -- Move cursor to corresponding edge of `a` textobject
          goto_left = '[',
          goto_right = ']',
        },
        custom_textobjects = {
          -- treesitter-textobject
          F = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
          c = require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
          o = require('mini.ai').gen_spec.treesitter({
            a = { '@conditional.outer', '@loop.outer' },
            i = { '@conditional.inner', '@loop.inner' },
          }),
          -- Mini.Extra
          B = require('mini.extra').gen_ai_spec.buffer(),
          D = require('mini.extra').gen_ai_spec.diagnostic(),
          I = require('mini.extra').gen_ai_spec.indent(),
          L = require('mini.extra').gen_ai_spec.line(),
          N = require('mini.extra').gen_ai_spec.number(),

          -- custom
          C = comment_block,
        },
      })
    end,
  },

  {
    'echasnovski/mini.surround',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      mappings = {
        add = 'ms',
        delete = 'md',
        find = 'mf',
        find_left = 'mF',
        highlight = 'mh',
        replace = 'mr',
        update_n_lines = 'mn',

        suffix_last = 'l',
        suffix_next = 'n',
      },
    },
  },
}
