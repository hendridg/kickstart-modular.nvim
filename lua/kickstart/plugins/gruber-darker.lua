return {
  {
    'blazkowolf/gruber-darker.nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'gruber-darker'

      vim.cmd.hi 'Comment gui=italic'
      vim.cmd.hi 'Visual guibg=#603101'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
