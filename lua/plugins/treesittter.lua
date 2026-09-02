return {
  'nvim-treesitter/nvim-treesitter',
  tag = "v0.10.0",
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = { "lua", "typescript", "tsx", "sql", "prisma" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
