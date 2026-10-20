return {
  "folke/persistence.nvim",
  lazy = false,
  config = function(_, opts)
    local persistence = require("persistence")
    persistence.setup(opts)
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePre",
      callback = function()
        pcall(require("nvim-tree.api").tree.close)
        -- directory buffers (from `nvim .`) count as files and would save an empty session
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          local name = vim.api.nvim_buf_get_name(b)
          if name ~= "" and vim.fn.isdirectory(name) == 1 then
            pcall(vim.api.nvim_buf_delete, b, { force = true })
          end
        end
      end,
    })
    -- older sessions saved an empty NvimTree_N buffer; drop it on restore
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceLoadPost",
      callback = function()
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_get_name(b):match("NvimTree_%d+$") then
            pcall(vim.api.nvim_buf_delete, b, { force = true })
          end
        end
      end,
    })
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        local argc = vim.fn.argc()
        local is_dir = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
        if argc == 0 or is_dir then
          vim.schedule(function()
            pcall(require("nvim-tree.api").tree.close)
            persistence.load()
            vim.schedule(function() pcall(require("nvim-tree.api").tree.open) end)
          end)
        end
      end,
      nested = true,
    })
  end,
  keys = {
    { "<leader>qs", function()
      local was_tree_open = require("nvim-tree.api").tree.is_visible()
      pcall(require("nvim-tree.api").tree.close)
      require("persistence").load()
      if was_tree_open then
        vim.schedule(function() pcall(require("nvim-tree.api").tree.open) end)
      end
    end, desc = "Restore session for cwd" },
    { "<leader>ql", function()
      local was_tree_open = require("nvim-tree.api").tree.is_visible()
      pcall(require("nvim-tree.api").tree.close)
      require("persistence").load({ last = true })
      if was_tree_open then
        vim.schedule(function() pcall(require("nvim-tree.api").tree.open) end)
      end
    end, desc = "Restore last session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
  },
}
