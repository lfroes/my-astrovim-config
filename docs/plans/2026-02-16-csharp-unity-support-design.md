# C# / Unity Support for Neovim

## Goal

Add C# language support to the Neovim config for Unity game development.

## Approach

Use AstroCommunity `pack.cs` as the base. This provides:

- **LSP**: `csharp_ls` with `csharpls-extended-lsp.nvim` for extended go-to-definition
- **Formatter**: `csharpier` via conform.nvim
- **Treesitter**: `c_sharp` parser for syntax highlighting
- **Debugging**: `netcoredbg` / `coreclr` (installed but not actively configured for now)
- **Testing**: `neotest-dotnet` for .NET test runner integration

## Changes

1. **`community.lua`**: Add `{ import = "astrocommunity.pack.cs" }`
2. **`astrolsp.lua`**: Add `"cs"` to `format_on_save.allow_filetypes`

## Prerequisites

- .NET SDK installed (`dotnet` in PATH)
- Unity generates `.sln` and `.csproj` files that `csharp_ls` reads

## Future considerations

- If `csharp_ls` proves insufficient for Unity projects, swap to OmniSharp via Mason + astrolsp config
- DAP debugging can be added later if needed
