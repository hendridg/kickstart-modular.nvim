return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = {
        char = '│', -- Character for normal indent lines
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
        highlight = 'IblScopeBlue', -- Use custom blue highlight for scope
        char = '│',
        -- Use box drawing characters for better alignment
        show_exact_scope = true,
      },
      whitespace = {
        remove_blankline_trail = false,
      },
    },
    config = function(_, opts)
      local hooks = require 'ibl.hooks'

      -- Set up the blue highlight for scope
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'IblScopeBlue', { fg = '#61AFEF', bold = true })
      end)

      require('ibl').setup(opts)
    end,
  },
}
