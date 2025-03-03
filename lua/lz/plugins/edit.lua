return {

  {
    'TheBlob42/houdini.nvim',
    event = { 'InsertEnter', 'CmdLineEnter', 'TermEnter' },
    opts = {
      escape_sequences = {
        ['v'] = false,
        ['V'] = false,
        ['c'] = '<BS><BS><Esc>',
      },
    },
  },

  {
    'windwp/nvim-autopairs',
    event = { 'InsertEnter' },
    opts = {
      disable_filetype = { 'vim' },
    },
  },

  {
    'hrsh7th/nvim-insx',
    event = { 'InsertEnter' },
    config = function() require('insx.preset.standard').setup({}) end,
  },

  {
    'julienvincent/nvim-paredit',
    ft = { 'clojure', 'fennel' },
    opts = {
      filetypes = { 'clojure', 'fennel' },
      keys = {
        ['du'] = { function() require('nvim-paredit').api.raise_form() end, 'Raise form' },
        ['dU'] = { function() require('nvim-paredit').api.raise_element() end, 'Raise element' },
        ['<s'] = {
          function()
            require('nvim-paredit').cursor.place_cursor(
              require('nvim-paredit').wrap.wrap_enclosing_form_under_cursor('( ', ')'),
              { placement = 'inner_start', mode = 'insert' }
            )
          end,
          'Wrap form insert head',
        },
        ['>s'] = {
          function()
            require('nvim-paredit').cursor.place_cursor(
              require('nvim-paredit').wrap.wrap_enclosing_form_under_cursor('(', ')'),
              { placement = 'inner_end', mode = 'insert' }
            )
          end,
          'Wrap form insert tail',
        },
      },
    },
  },

  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      { '<Leader>j', function() require('treesj').toggle() end, desc = 'Split/Join' },
    },
    opts = {
      use_default_keymaps = false,
    },
  },

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
