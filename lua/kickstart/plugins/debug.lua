-- debug.lua
--
-- Muestra cómo usar el plugin DAP para depurar tu código.
--
-- Principalmente enfocado en configurar el depurador para Go, pero puede
-- extenderse a otros lenguajes también. Por eso se llama
-- kickstart.nvim y no kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',
    -- Shows virtual text for variables in the current scope
    'theHamsta/nvim-dap-virtual-text',
    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'elixir-ls', -- Only for debugging, Expert handles LSP
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        enabled = true,
        element = 'repl',
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      mappings = {
        -- Use default mappings
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
        toggle = 't',
      },
      element_mappings = {},
      expand_lines = true,
      force_buffers = true,
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 0.25 },
          },
          size = 40,
          position = 'left',
        },
        {
          elements = {
            { id = 'repl', size = 0.5 },
            { id = 'console', size = 0.5 },
          },
          size = 10,
          position = 'bottom',
        },
      },
      floating = {
        max_height = 20, -- Maximum 20 lines
        max_width = 80, -- Maximum 80 characters
        border = 'rounded',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      render = {
        indent = 1,
        max_type_length = nil,
        max_value_lines = 100,
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    require('nvim-dap-virtual-text').setup {
      -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
      display_callback = function(variable)
        local name = string.lower(variable.name)
        local value = string.lower(variable.value)
        if name:match 'secret' or name:match 'api' or value:match 'secret' or value:match 'api' then
          return '*****'
        end

        if #variable.value > 15 then
          return ' ' .. string.sub(variable.value, 1, 15) .. '... '
        end

        return ' ' .. variable.value
      end,
    }

    -- Handled by nvim-dap-go
    -- dap.adapters.go = {
    --   type = "server",
    --   port = "${port}",
    --   executable = {
    --     command = "dlv",
    --     args = { "dap", "-l", "127.0.0.1:${port}" },
    --   },
    -- }

    -- Elixir debugging configuration
    -- Note: We use ElixirLS only for debugging, Expert handles LSP
    local elixir_ls_debugger = vim.fn.exepath 'elixir-ls-debugger'
    if elixir_ls_debugger ~= '' then
      dap.adapters.mix_task = {
        type = 'executable',
        command = elixir_ls_debugger,
      }

      dap.configurations.elixir = {
        {
          type = 'mix_task',
          name = 'mix test',
          task = 'test',
          taskArgs = { '--trace' },
          request = 'launch',
          startApps = true,
          projectDir = '${workspaceFolder}',
          requireFiles = {
            'test/**/test_helper.exs',
            'test/**/*_test.exs',
          },
        },
        {
          type = 'mix_task',
          name = 'mix test (current file)',
          task = 'test',
          taskArgs = { '${file}' },
          request = 'launch',
          startApps = true,
          projectDir = '${workspaceFolder}',
          requireFiles = {
            'test/**/test_helper.exs',
            '${file}',
          },
        },
        {
          type = 'mix_task',
          name = 'phoenix server',
          task = 'phx.server',
          request = 'launch',
          projectDir = '${workspaceFolder}',
          exitAfterTaskReturns = false,
          debugAutoInterpretAllModules = false,
        },
        {
          type = 'mix_task',
          name = 'phoenix server (with Docker DB)',
          task = 'phx.server',
          request = 'launch',
          projectDir = '${workspaceFolder}',
          exitAfterTaskReturns = false,
          debugAutoInterpretAllModules = false,
          env = {
            -- Use Docker database (running on port 5433 per docker-compose.yml)
            DATABASE_HOST = 'localhost',
            DATABASE_PORT = '5433',
            DATABASE_USER = 'postgres',
            DATABASE_PASSWORD = 'postgres',
            DATABASE_NAME = 'synapse_commerce_dev',
            PHX_HOST = 'localhost',
            PHX_PORT = '4000',
            MIX_ENV = 'dev',
          },
        },
        {
          type = 'mix_task',
          name = 'mix run (custom task)',
          task = 'run',
          taskArgs = function()
            local args = vim.fn.input 'Task args: '
            return vim.split(args, ' ')
          end,
          request = 'launch',
          projectDir = '${workspaceFolder}',
        },
      }
    end

    -- vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
    -- vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

    -- Eval var under cursor - Auto-sizes to content (respects max 80x20 from config)
    -- When no width/height specified, dapui automatically adjusts to content
    vim.keymap.set('n', '<space>?', function()
      require('dapui').eval(nil, { enter = true })
    end, { desc = 'Debug: Eval variable under cursor' })

    -- Eval with visual selection
    vim.keymap.set('v', '<space>?', function()
      require('dapui').eval()
    end, { desc = 'Debug: Eval selected expression' })

    -- Custom command: Start Docker DB and begin debugging
    vim.api.nvim_create_user_command('DebugWithDocker', function()
      -- Find project root (where docker-compose.yml is)
      local docker_compose = vim.fn.findfile('docker-compose.yml', '.;')
      if docker_compose == '' then
        docker_compose = vim.fn.findfile('compose.yml', '.;')
      end

      if docker_compose ~= '' then
        local project_root = vim.fn.fnamemodify(docker_compose, ':h')
        vim.notify('🐳 Starting Docker database...', vim.log.levels.INFO)

        -- Start only the db service in background
        vim.fn.jobstart('cd ' .. project_root .. ' && docker compose up -d db', {
          on_exit = function(_, exit_code)
            if exit_code == 0 then
              vim.notify('✅ Docker DB started. Waiting 5 seconds for initialization...', vim.log.levels.INFO)
              -- Wait for DB to be ready
              vim.defer_fn(function()
                vim.notify('🚀 Starting debugger...', vim.log.levels.INFO)
                -- Start debugging with the Docker DB configuration
                require('dap').continue()
              end, 5000)
            else
              vim.notify('❌ Failed to start Docker DB', vim.log.levels.ERROR)
            end
          end,
        })
      else
        vim.notify('⚠️  docker-compose.yml not found', vim.log.levels.WARN)
      end
    end, { desc = 'Start Docker DB and debug Phoenix' })

    -- Optional: Add a keymap for quick access
    vim.keymap.set('n', '<leader>dd', '<cmd>DebugWithDocker<cr>', { desc = 'Debug with Docker' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
