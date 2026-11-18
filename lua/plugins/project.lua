return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      -- no "lsp": it roots monorepos at apps/api
      detection_methods = { "pattern" },
      patterns = { ".git", "Makefile", "*.sln", ".nvim.lua" },
      show_hidden = false,
      silent_chdir = true,
    })
  end,
}
