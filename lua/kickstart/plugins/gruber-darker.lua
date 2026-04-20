return {
  {
    'blazkowolf/gruber-darker.nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'gruber-darker'

      vim.cmd.hi 'Comment gui=italic'
      vim.cmd.hi 'Visual guibg=#603101'

      -- Statusline contrast
      vim.cmd.hi 'MiniStatuslineModeNormal guifg=#181818 guibg=#95a99f gui=bold'
      vim.cmd.hi 'MiniStatuslineFilename guifg=#e4e4ef guibg=#3e3e3e'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
