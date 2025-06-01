
return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- opcional, mas recomendável
  config = function()
    require("fzf-lua").setup({
      -- configs opcionais
    })
  end,
}
