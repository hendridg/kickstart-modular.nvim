return {
  -- {
  --   'rmagatti/auto-session',
  --   opts = {
  --     log_level = 'info',
  --     auto_session_suppress_dirs = { '~/', '~/Projects' },
  --   },
  -- },
  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'Open LazyGit UI' })
    end,
  },
}
