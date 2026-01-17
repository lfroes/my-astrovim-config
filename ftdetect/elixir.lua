-- Elixir filetype detection
-- This file ensures proper filetype detection for Elixir and Phoenix LiveView files

-- Detect .heex files as heex filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.heex",
  command = "setfiletype heex",
})

-- Detect .eex files as eex filetype (for standard Phoenix templates)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.eex",
  command = "setfiletype eex",
})

-- Detect .leex files as eex filetype (for legacy Phoenix LiveView templates)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.leex",
  command = "setfiletype eex",
})
