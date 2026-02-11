return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  build = ':Copilot auth',
  event = 'InsertEnter',
  opts = {
    suggestion = {
      enabled = not vim.g.ai_cmp,
      auto_trigger = true,
      hide_during_completion = vim.g.ai_cmp,
      keymap = {
        accept = false, -- Disable auto keymap, we'll set it manually below
        accept_word = false,
        accept_line = false,
        next = false,
        prev = false,
        dismiss = false,
      },
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
  config = function(_, opts)
    require('copilot').setup(opts)

    -- Manually set keymaps to avoid duplicate registration
    vim.keymap.set('i', '<CR>', function()
      local copilot_suggestion = require('copilot.suggestion')
      if copilot_suggestion.is_visible() then
        copilot_suggestion.accept()
      else
        -- Fallback to default Enter behavior
        local keys = vim.api.nvim_replace_termcodes('<CR>', true, true, true)
        vim.api.nvim_feedkeys(keys, 'n', false)
      end
    end, { noremap = true, silent = true, desc = 'Accept Copilot suggestion or insert newline' })

    vim.keymap.set('i', '<M-]>', function()
      require('copilot.suggestion').next()
    end, { desc = 'Next Copilot suggestion' })

    vim.keymap.set('i', '<M-[>', function()
      require('copilot.suggestion').prev()
    end, { desc = 'Previous Copilot suggestion' })

    vim.keymap.set('i', '<C-]>', function()
      require('copilot.suggestion').dismiss()
    end, { desc = 'Dismiss Copilot suggestion' })
  end,
}
