return {
  "folke/persistence.nvim",
  lazy = false,
  opts = {
    pre_save = function()
      pcall(require("nvim-tree.api").tree.close)
    end,
  },
  config = function(_, opts)
    local persistence = require("persistence")
    persistence.setup(opts)
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        local argc = vim.fn.argc()
        local is_dir = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
        if argc == 0 or is_dir then
          vim.schedule(function()
            persistence.load()
          end)
        end
      end,
      nested = true,
    })
  end,
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore session for cwd" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
  },
}
