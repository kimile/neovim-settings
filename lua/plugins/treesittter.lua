return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.config').setup({
      ensure_installed = { "lua", "typescript", "tsx", "sql" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
