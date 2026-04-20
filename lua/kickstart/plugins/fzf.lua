return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  ---@module "fzf-lua"
  ---@type fzf-lua.Config|{}
  ---@diagnostic disable: missing-fields
  opts = {},
  keys = {
    -- Search (same as Telescope)
    { '<leader>sh', '<cmd>FzfLua helptags<CR>', desc = '[S]earch [H]elp' },
    { '<leader>sk', '<cmd>FzfLua keymaps<CR>', desc = '[S]earch [K]eymaps' },
    { '<leader>sf', '<cmd>FzfLua files<CR>', desc = '[S]earch [F]iles' },
    { '<leader>ss', '<cmd>FzfLua builtin<CR>', desc = '[S]earch [S]elect FzfLua' },
    { '<leader>sw', '<cmd>FzfLua grep_cword<CR>', desc = '[S]earch current [W]ord' },
    {
      '<leader>sg',
      function()
        require('fzf-lua').live_grep { resume = true }
      end,
      desc = '[S]earch by [G]rep',
    },
    { '<leader>sd', '<cmd>FzfLua diagnostics_workspace<CR>', desc = '[S]earch [D]iagnostics' },
    { '<leader>sr', '<cmd>FzfLua resume<CR>', desc = '[S]earch [R]esume' },
    { '<leader>s.', '<cmd>FzfLua oldfiles<CR>', desc = '[S]earch Recent Files ("." for repeat)' },
    { '<leader><leader>', '<cmd>FzfLua buffers<CR>', desc = '[ ] Find existing buffers' },
    {
      '<leader>/',
      function()
        require('fzf-lua').lgrep_curbuf()
      end,
      desc = '[/] Fuzzily search in current buffer',
    },
    {
      '<leader>s/',
      function()
        require('fzf-lua').live_grep { grep_open_files = true }
      end,
      desc = '[S]earch [/] in Open Files',
    },
    {
      '<leader>sn',
      function()
        require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
    -- Git
    { '<leader>sgc', '<cmd>FzfLua git_commits<CR>', desc = '[S]earch [G]it [C]ommits' },
    { '<leader>sgb', '<cmd>FzfLua git_branches<CR>', desc = '[S]earch [G]it [B]ranches' },
    { '<leader>sgs', '<cmd>FzfLua git_status<CR>', desc = '[S]earch [G]it [S]tatus' },
    -- LSP (same keys as commented out in lspconfig)
    { 'gd', '<cmd>FzfLua lsp_definitions<CR>', desc = '[G]oto [D]efinition' },
    { 'gr', '<cmd>FzfLua lsp_references<CR>', desc = '[G]oto [R]eferences' },
    { 'gI', '<cmd>FzfLua lsp_implementations<CR>', desc = '[G]oto [I]mplementation' },
    { 'gD', '<cmd>FzfLua lsp_declarations<CR>', desc = '[G]oto [D]eclaration' },
    { '<leader>D', '<cmd>FzfLua lsp_typedefs<CR>', desc = 'Type [D]efinition' },
    { '<leader>ds', '<cmd>FzfLua lsp_document_symbols<CR>', desc = '[D]ocument [S]ymbols' },
    { '<leader>ws', '<cmd>FzfLua lsp_live_workspace_symbols<CR>', desc = '[W]orkspace [S]ymbols' },
    { '<leader>ca', '<cmd>FzfLua lsp_code_actions<CR>', desc = '[C]ode [A]ction', mode = { 'n', 'x' } },
  },
  ---@diagnostic enable: missing-fields
}
