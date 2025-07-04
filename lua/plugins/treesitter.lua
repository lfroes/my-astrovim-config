-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "go",
      "gosum",
      "gomod",
      "typescript",
      "javascript",
      "tsx",
      "json",
      "html",
      "css",
      -- add more arguments for adding more treesitter parsers
    },
  },
}
