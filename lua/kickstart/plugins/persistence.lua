-- Session management - Auto save and restore sessions
-- https://github.com/folke/persistence.nvim
return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {
    dir = vim.fn.expand(vim.fn.stdpath 'state' .. '/sessions/'), -- directory where session files are saved
    options = { 'buffers', 'curdir', 'tabpages', 'winsize' }, -- sessionoptions used for saving
  },
  config = function(_, opts)
    require('persistence').setup(opts)

    -- Auto-restore session when opening nvim without arguments
    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('persistence_auto_restore', { clear = true }),
      callback = function()
        -- Only load the session if nvim was started with no arguments
        if vim.fn.argc() == 0 then
          require('persistence').load()
        end
      end,
      nested = true,
    })
  end,
  keys = {
    {
      '<leader>qs',
      function()
        require('persistence').load()
      end,
      desc = '[Q]uit [S]ession: Restore session for current directory',
    },
    {
      '<leader>ql',
      function()
        require('persistence').load { last = true }
      end,
      desc = '[Q]uit [L]ast: Restore last session',
    },
    {
      '<leader>qd',
      function()
        require('persistence').stop()
      end,
      desc = "[Q]uit [D]on't save: Stop session save on exit",
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
