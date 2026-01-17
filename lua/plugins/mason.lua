---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",
        "gopls",
        "typescript-language-server",
        "tailwindcss-language-server",
        "deno",

        -- install formatters
        "stylua",

        -- install debuggers
        "debugpy",
        "js-debug-adapter",
        "java-debug-adapter",
        "java-test",

        -- install java language server
        "jdtls",

        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
}
