return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    -- https://github.com/ankushbhagats/pastel.nvim,
    'ankushbhagats/pastel.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- You can configure highlights by doing something like:
      -- vim.cmd.colorscheme 'pastelrose'

      -- vim.cmd.hi 'Comment gui=italic'
      -- vim.cmd.hi 'Visual gui=none'
      -- vim.cmd.hi 'Visual guibg=#333a3b'
      -- vim.cmd.hi 'Visual guibg=#808980'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
