return {
  'zbirenbaum/copilot-cmp',
  'LazyVim/LazyVim',
  opts = {
    function()
      local LazyVim = require 'LazyVim'
      LazyVim.cmp.actions.ai_accept = function()
        if require('copilot.suggestion').is_visible() then
          LazyVim.create_undo()
          require('copilot.suggestion').accept()
          return true
        end
      end
    end,
  },
  config = function(_, opts)
    local copilot_cmp = require 'copilot_cmp'
    local LazyVim = require 'LazyVim'
    copilot_cmp.setup(opts)
    -- attach cmp source whenever copilot attaches
    -- fixes lazy-loading issues with the copilot cmp source
    LazyVim.lsp.on_attach(function()
      copilot_cmp._on_insert_enter {}
    end, 'copilot')
  end,
  specs = {
    {
      'hrsh7th/nvim-cmp',
      optional = true,
      -- @param opts cmp.ConfigSchema
      opts = function(_, opts)
        table.insert(opts.sources, 1, {
          name = 'copilot',
          group_index = 1,
          priority = 100,
        })
      end,
    },
  },
}
