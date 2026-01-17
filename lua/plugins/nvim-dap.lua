return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mxsdev/nvim-dap-vscode-js",
      "Joakker/lua-json5",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      
      -- Setup DAP UI
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
          expand = { "<CR>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
      })
      
      -- Auto-open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Configure JavaScript/TypeScript debugging via vscode-js
      local ok, dap_vscode_js = pcall(require, "dap-vscode-js")
      if ok then
        local debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"
        local debugger_cmd = { vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter", "0", "127.0.0.1" }
        dap_vscode_js.setup {
          debugger_path = debugger_path,
          debugger_cmd = debugger_cmd,
          adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal" },
        }

        local qwik_configs = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Qwik SSR dev",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "npm",
            runtimeArgs = { "run", "dev" },
            console = "integratedTerminal",
            env = { NODE_OPTIONS = "--inspect" },
            sourceMaps = true,
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
            skipFiles = { "<node_internals>/**" },
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Qwik client (Chrome)",
            url = "http://localhost:5173",
            webRoot = "${workspaceFolder}",
            runtimeExecutable = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
          },
        }

        dap.configurations.javascript = vim.deepcopy(qwik_configs)
        dap.configurations.typescript = vim.deepcopy(qwik_configs)
        dap.configurations.javascriptreact = vim.deepcopy(qwik_configs)
        dap.configurations.typescriptreact = vim.deepcopy(qwik_configs)
      end
      
      -- Elixir DAP configuration
      dap.configurations.elixir = {
        {
          type = "mix_task",
          name = "mix test",
          request = "launch",
          task = "test",
          taskArgs = { "--trace" },
          projectDir = "${workspaceFolder}",
          requireFiles = {
            "test/**/test_helper.exs",
            "test/**/*_test.exs"
          },
          startApps = true,
          debugAutoInterpretAllModules = false,
        },
        {
          type = "mix_task",
          name = "mix phx.server",
          request = "launch",
          task = "phx.server",
          projectDir = "${workspaceFolder}",
          startApps = true,
          debugAutoInterpretAllModules = false,
        },
        {
          type = "mix_task",
          name = "mix run",
          request = "launch",
          task = "run",
          taskArgs = { "--no-halt" },
          projectDir = "${workspaceFolder}",
          startApps = true,
          debugAutoInterpretAllModules = false,
        },
        {
          type = "mix_task",
          name = "mix run (with breakpoints)",
          request = "launch",
          task = "run",
          taskArgs = { "--no-halt" },
          projectDir = "${workspaceFolder}",
          startApps = true,
          debugAutoInterpretAllModules = true,
        },
      }
      
      dap.adapters.mix_task = {
        type = "executable",
        command = "elixir",
        args = { "-e", "Mix.install([{:debugger, \"~> 0.2\"}]); Debugger.start()" },
      }
    end,
  },
  {
    "elixir-tools/elixir-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("elixir").setup({
        nextls = {
          enable = true,
          init_options = {
            mix_env = "dev",
            mix_target = "host",
            experimental = {
              completions = {
                enable = true,
              },
            },
          },
        },
        elixirls = {
          enable = true,
          settings = {
            dialyzerEnabled = true,
            enableTestLenses = true,
            suggestSpecs = true,
            fetchDeps = true,
          },
        },
        projectionist = {
          enable = true,
        },
      })
    end,
  },
}
