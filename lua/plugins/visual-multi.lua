return {
  "mg979/vim-visual-multi",
  branch = "master", -- importante para evitar bugs
  init = function()
    vim.g.VM_default_mappings = 1 -- ou 0 se quiser customizar
  end,
}
