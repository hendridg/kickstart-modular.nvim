return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    {
      '<leader>tt',
      function()
        vim.cmd(vim.v.count1 .. 'ToggleTerm')
      end,
      desc = 'Toggle terminal (Nth)',
    },
    { '<leader>tT', '<cmd>ToggleTermToggleAll<CR>', desc = 'Toggle all terminals' },
  },
  config = true,
}
