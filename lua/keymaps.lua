-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Scratch buffer functionality
local scratch_count = 0
vim.keymap.set('n', '<leader>.', function()
  scratch_count = scratch_count + 1
  vim.cmd 'enew'
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'hide'
  vim.bo.swapfile = false
  vim.bo.buflisted = true
  vim.api.nvim_buf_set_name(0, 'Scratch' .. (scratch_count > 1 and (' ' .. scratch_count) or ''))
end, { desc = 'Abrir buffer scratch' })

-- Atajo para cerrar el buffer actual con <leader>q
vim.keymap.set('n', '<leader>q', ':bd<CR>', { desc = 'Cerrar buffer actual' })

-- Atajo para cerrar los otros buffers con <leader>Q
vim.keymap.set('n', '<leader>Q', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local closed_buffers = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= bufnr and vim.api.nvim_buf_is_loaded(b) then
      local name = vim.api.nvim_buf_get_name(b)
      print('Buffer name:', name)
      if not name:match '[/\\]?Scratch[: ]?%d*$' then
        vim.api.nvim_buf_delete(b, { force = true })
        table.insert(closed_buffers, name)
      end
    end
  end
  if #closed_buffers > 0 then
    local msg = 'Buffers cerrados:\n'
    for _, name in ipairs(closed_buffers) do
      msg = msg .. '  ' .. name .. '\n'
    end
    print(msg)
  else
    print 'No se cerraron buffers.'
  end
end, { desc = 'Cerrar otros buffers' })

-- vim: ts=2 sts=2 sw=2 et
