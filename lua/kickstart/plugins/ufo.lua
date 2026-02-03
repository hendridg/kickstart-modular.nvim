-- Ultra fold with Treesitter - Better code folding
return {
  'kevinhwang91/nvim-ufo',
  event = 'VeryLazy',
  dependencies = {
    'kevinhwang91/promise-async',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    provider_selector = function()
      return { 'treesitter', 'indent' }
    end,
  },
  keys = {
    {
      'zR',
      function()
        require('ufo').openAllFolds()
      end,
      desc = 'Open all folds',
    },
    {
      'zM',
      function()
        require('ufo').closeAllFolds()
      end,
      desc = 'Close all folds',
    },
    {
      'zr',
      function()
        require('ufo').openFoldsExceptKinds()
      end,
      desc = 'Open folds except kinds',
    },
    {
      'zm',
      function()
        require('ufo').closeFoldsWith()
      end,
      desc = 'Close folds with',
    },
    {
      'K',
      function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end,
      desc = 'Peek Fold or Hover',
    },
  },
  config = function(_, opts)
    require('ufo').setup(opts)
    -- Using ufo provider need remap `zR` and `zM`
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
  end,
}
-- vim: ts=2 sts=2 sw=2 et
