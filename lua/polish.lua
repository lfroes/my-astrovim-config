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
