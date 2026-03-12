return {
  'nvim-neorg/neorg',
  lazy = false,
  version = '*',
  config = function()
    require('neorg').setup {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = {},
        ['core.dirman'] = {
          config = {
            workspaces = {
              notes = '~/notes',
            },
            default_workspace = 'notes',
          },
        },
      },
    }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'norg',
      callback = function(args)
        vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2
        -- Forzar treesitter highlighting en buffers norg
        pcall(vim.treesitter.start, args.buf, 'norg')
      end,
    })

    -- Keymaps globales para Neorg
    vim.keymap.set('n', '<leader>nn', '<cmd>Neorg index<CR>', { desc = '[N]eorg [I]ndex' })
    vim.keymap.set('n', '<leader>nr', '<cmd>Neorg return<CR>', { desc = '[N]eorg [R]eturn' })
    vim.keymap.set('n', '<leader>nw', '<cmd>Neorg workspace<CR>', { desc = '[N]eorg [W]orkspace' })
    vim.keymap.set('n', '<leader>nj', '<cmd>Neorg journal today<CR>', { desc = '[N]eorg [J]ournal today' })
    vim.keymap.set('n', '<leader>nc', function()
      local name = vim.fn.input 'Note name: '
      if name ~= '' then
        vim.cmd('edit ' .. vim.fn.expand '~/notes/' .. name .. '.norg')
      end
    end, { desc = '[N]eorg [C]reate note' })
  end,
}
