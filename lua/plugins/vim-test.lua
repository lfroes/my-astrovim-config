---@type LazySpec
return {
  "vim-test/vim-test",
  event = "VeryLazy",
  config = function()
    -- Set test runner to mix test for Elixir
    vim.g["test#elixir#mix#executable"] = "mix"
    
    -- Configure test strategy (optional - you can use 'basic', 'neovim', 'dispatch', etc.)
    vim.g["test#strategy"] = "neovim"
    
    -- Optional: Set test file patterns for Elixir
    vim.g["test#elixir#patterns"] = {
      "test/.*_test.exs$",
      "spec/.*_spec.exs$",
    }
    
    -- Key mappings for vim-test
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }
    
    -- Main test commands
    keymap("n", "<leader>t", ":TestFile<CR>", opts)           -- Test current file
    keymap("n", "<leader>tn", ":TestNearest<CR>", opts)       -- Test nearest to cursor
    keymap("n", "<leader>ts", ":TestSuite<CR>", opts)         -- Test entire suite
    keymap("n", "<leader>tl", ":TestLast<CR>", opts)          -- Re-run last test
    keymap("n", "<leader>tv", ":TestVisit<CR>", opts)         -- Visit test file
    
    -- Additional useful mappings
    keymap("n", "<leader>tf", ":TestFile<CR>", opts)          -- Alternative for test file
    keymap("n", "<leader>ta", ":TestSuite<CR>", opts)         -- Alternative for test all
  end,
}
