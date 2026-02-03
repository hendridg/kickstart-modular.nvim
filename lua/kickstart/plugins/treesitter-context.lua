-- Shows the context of the current function/class at the top of the screen
return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'VeryLazy',
  opts = {
    enable = true,
    max_lines = 3, -- How many lines the window should span
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to collapse
    trim_scope = 'outer', -- Which context lines to discard if max_lines is exceeded
    mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
    separator = nil, -- Separator between context and content
  },
  keys = {
    {
      '<leader>tc',
      function()
        require('treesitter-context').toggle()
      end,
      desc = '[T]oggle Treesitter [C]ontext',
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
