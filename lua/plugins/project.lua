return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "package.json", "Makefile", "*.sln", ".nvim.lua" },
      show_hidden = false,
      silent_chdir = true,
    })
  end,
}
