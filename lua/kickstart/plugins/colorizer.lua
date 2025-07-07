return {
  {
    'brenoprata10/nvim-highlight-colors',
    config = function()
      require('nvim-highlight-colors').setup {
        render = 'background', -- o 'foreground'
        enable_tailwind = true,
      }
    end,
    lazy = false,
  },
}
