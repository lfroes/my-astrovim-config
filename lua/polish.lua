-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Ensure Volta is in PATH for macOS
local home = os.getenv("HOME")
if home then
  local volta_bin = home .. "/.volta/bin"
  local current_path = os.getenv("PATH") or ""
  if not string.find(current_path, volta_bin, 1, true) then
    vim.env.PATH = volta_bin .. ":" .. current_path
  end
end

-- Jump straight to the first LSP definition result when using `gd`
do
  local util = vim.lsp.util
  vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, config)
    if err then
      vim.notify(err.message or "LSP definition error", vim.log.levels.ERROR)
      return
    end

    if not result or vim.tbl_isempty(result) then
      vim.notify("No definition found", vim.log.levels.INFO)
      return
    end

    local locations = vim.tbl_islist(result) and result or { result }
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end

    util.jump_to_location(locations[1], client.offset_encoding, vim.tbl_extend("keep", config or {}, { reuse_win = true }))

    if #locations > 1 then
      vim.fn.setqflist({}, " ", {
        title = "LSP definitions",
        items = util.locations_to_items(locations, client.offset_encoding),
      })
    end
  end
end
