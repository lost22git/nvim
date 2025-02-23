return {

  --------------
  -- 快速 ESC --
  --------------

  {
    'TheBlob42/houdini.nvim',
    event = { 'InsertEnter', 'CmdLineEnter', 'TermEnter' },
    config = function()
      require('houdini').setup({
        escape_sequences = {
          ['v'] = false,
          ['V'] = false,
        },
      })
    end,
  },

  ------------------
  -- 自动补全括号 --
  ------------------

  {
    'windwp/nvim-autopairs',
    event = { 'InsertEnter' },
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { 'vim' },
      })
    end,
  },

  {
    'hrsh7th/nvim-insx',
    event = { 'InsertEnter' },
    config = function() require('insx.preset.standard').setup({}) end,
  },

  -------------
  -- paredit --
  -------------

  {
    'julienvincent/nvim-paredit',
    ft = { 'clojure', 'fennel' },
    config = function()
      local paredit = require('nvim-paredit')
      paredit.setup({
        filetypes = { 'clojure', 'fennel' },
        keys = {
          ['du'] = { paredit.api.raise_form, 'Raise form' },
          ['dU'] = { paredit.api.raise_element, 'Raise element' },
          ['<s'] = {
            function()
              paredit.cursor.place_cursor(
                paredit.wrap.wrap_enclosing_form_under_cursor('( ', ')'),
                { placement = 'inner_start', mode = 'insert' }
              )
            end,
            'Wrap form insert head',
          },
          ['>s'] = {
            function()
              paredit.cursor.place_cursor(
                paredit.wrap.wrap_enclosing_form_under_cursor('(', ')'),
                { placement = 'inner_end', mode = 'insert' }
              )
            end,
            'Wrap form insert tail',
          },
        },
      })
    end,
  },

  --------------------
  -- split or join --
  --------------------

  {
    'Wansmer/treesj',
    keys = { '<Leader>j' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({
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
      })

      require('core.maps').treesj()
    end,
  },

  --------------------
  -- 可视区域内跳转 --
  --------------------

  {
    'folke/flash.nvim',
    opts = {},
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function() require('flash').jump() end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'o', 'x' },
        function() require('flash').treesitter() end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function() require('flash').remote() end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function() require('flash').treesitter_search() end,
        desc = 'Flash Treesitter Search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function() require('flash').toggle() end,
        desc = 'Toggle Flash Search',
      },
    },
  },
}
