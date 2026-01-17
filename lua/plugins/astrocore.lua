-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    defaults = {
      mappings = false,
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- DAP mappings
        -- Start/Continue
        ["<F5>"] = {
          function() require("dap").continue() end,
          desc = "Start or Continue Debugging",
        },
        -- Toggle Breakpoint
        ["<F9>"] = {
          function() require("dap").toggle_breakpoint() end,
          desc = "Toggle Breakpoint",
        },
        -- Step Over
        ["<F10>"] = {
          function() require("dap").step_over() end,
          desc = "Step Over",
        },
        -- Step Into
        ["<F11>"] = {
          function() require("dap").step_into() end,
          desc = "Step Into",
        },
        -- Step Out
        ["<F12>"] = {
          function() require("dap").step_out() end,
          desc = "Step Out",
        },
        -- Open DAP UI
        ["<leader>du"] = {
          function() require("dapui").toggle() end,
          desc = "Toggle DAP UI",
        },
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["<A-l>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<A-h>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        ["<leader><leader>"] = {
          function() require("snacks").picker("files", {}) end,
          desc = "Find Files",
        },

        ["<leader>FW"] = {
          function() require("snacks").picker("grep_word", {}) end,
          desc = "Grep word under cursor",
        },

        ["<leader>fw"] = {
          function() require("snacks").picker("live_grep", {}) end,
          desc = "Live grep",
        },

        ["<leader>vt"] = { "<cmd>ToggleTerm direction=vertical<cr>", desc = "Toggle vertical terminal" },

        -- ["<leader>k"] = {
        --   function() require("snacks").picker.buffers() end,
        --   desc = "Find Buffers",
        -- },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
  },
}
