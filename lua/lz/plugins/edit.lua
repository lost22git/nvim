return {
  {
    'mbbill/undotree',
    cmd = { 'UndotreeToggle' },
    keys = {
      { '<Leader>u', vim.cmd.UndotreeToggle, desc = '[undotree] Toggle' },
    },
  },

  {
    'julienvincent/nvim-paredit',
    ft = { 'clojure', 'fennel' },
    opts = {
      filetypes = { 'clojure', 'fennel' },
      keys = {
        ['du'] = { function() require('nvim-paredit').api.raise_form() end, 'Raise form' },
        ['dU'] = { function() require('nvim-paredit').api.raise_element() end, 'Raise element' },
        ['>D'] = { function() require('nvim-paredit').api.drag_pair_forwards() end, 'Drag element pairs right' },
        ['<D'] = { function() require('nvim-paredit').api.drag_pair_backwards() end, 'Drag element pairs left' },
        ['>E'] = { function() require('nvim-paredit').api.drag_element_forwards() end, 'Drag element right' },
        ['<E'] = { function() require('nvim-paredit').api.drag_element_backwards() end, 'Drag element left' },
        ['>F'] = { function() require('nvim-paredit').api.drag_form_forwards() end, 'Drag form right' },
        ['<F'] = { function() require('nvim-paredit').api.drag_form_backwards() end, 'Drag form left' },
        ['<A'] = {
          function()
            require('nvim-paredit').cursor.place_cursor(
              require('nvim-paredit').wrap.wrap_enclosing_form_under_cursor('( ', ')'),
              { placement = 'inner_start', mode = 'insert' }
            )
          end,
          'Wrap form insert head',
        },
        ['>A'] = {
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
      { '<Leader>j', function() require('treesj').toggle() end, desc = '[treesj] Split/Join' },
    },
    opts = { use_default_keymaps = false },
  },

  {
    'folke/flash.nvim',
    opts = {
      modes = {
        char = { enabled = false },
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function() require('flash').jump() end,
        desc = '[flash] Flash',
      },
      {
        'S',
        mode = { 'n', 'o', 'x' },
        function() require('flash').treesitter() end,
        desc = '[flash] Treesitter',
      },
      {
        'r',
        mode = 'o',
        function() require('flash').remote() end,
        desc = '[flash] Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function() require('flash').treesitter_search() end,
        desc = '[flash] Treesitter Search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function() require('flash').toggle() end,
        desc = '[flash] Toggle Search',
      },
    },
  },

  {
    'aaronik/treewalker.nvim',
    keys = {
      { 'th', '<Cmd>Treewalker Left<CR>', mode = { 'n', 'v' }, desc = '[treewalker] Left' },
      { 'tl', '<Cmd>Treewalker Right<CR>', mode = { 'n', 'v' }, desc = '[treewalker] Right' },
      { 'tk', '<Cmd>Treewalker Up<CR>', mode = { 'n', 'v' }, desc = '[treewalker] Up' },
      { 'tj', '<Cmd>Treewalker Down<CR>', mode = { 'n', 'v' }, desc = '[treewalker] Down' },

      { 'tsh', '<Cmd>Treewalker SwapLeft<CR>', desc = '[treewalker] SwapLeft' },
      { 'tsl', '<Cmd>Treewalker SwapRight<CR>', desc = '[treewalker] SwapRight' },
      { 'tsk', '<Cmd>Treewalker SwapUp<CR>', desc = '[treewalker] SwapUp' },
      { 'tsj', '<Cmd>Treewalker SwapDown<CR>', desc = '[treewalker] SwapDown' },
    },
    opts = {
      highlight = true,
      highlight_duration = 300,
      highlight_group = 'Visual',
    },
  },
}
