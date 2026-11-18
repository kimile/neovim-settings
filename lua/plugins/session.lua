return {
  "folke/persistence.nvim",
  lazy = false,
  config = function(_, opts)
    local persistence = require("persistence")
    persistence.setup(opts)
    -- don't restore cwd from session: a stale `cd apps/api` would re-root the tree
    vim.opt.sessionoptions:remove("curdir")
    -- One session per git repo: key on the git root (not cwd) and ignore the branch.
    persistence.current = function()
      local cwd = vim.fn.getcwd()
      local root = vim.fn.systemlist({ "git", "-C", cwd, "rev-parse", "--show-toplevel" })[1]
      if vim.v.shell_error ~= 0 or not root or root == "" then root = cwd end
      return require("persistence.config").options.dir .. root:gsub("[\\/:]+", "%%") .. ".vim"
    end
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePre",
      callback = function()
        pcall(require("nvim-tree.api").tree.close)
        -- diffview panes restore as plain windows (no scrollbind/diff), so don't save them
        pcall(vim.cmd, "DiffviewClose")
        -- directory buffers (from `nvim .`) count as files and would save an empty session
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          local name = vim.api.nvim_buf_get_name(b)
          if name ~= "" and vim.fn.isdirectory(name) == 1 then
            pcall(vim.api.nvim_buf_delete, b, { force = true })
          end
        end
        -- nothing real open: skip the save so it can't overwrite a good session with an empty one
        local has_file = false
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          local name = vim.api.nvim_buf_get_name(b)
          if vim.bo[b].buflisted and vim.bo[b].buftype == "" and name ~= "" and vim.fn.isdirectory(name) == 0 then
            has_file = true
            break
          end
        end
        if not has_file then
          require("persistence.config").options.need = math.huge
        end
      end,
    })
    -- older sessions saved an empty NvimTree_N buffer; drop it on restore
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceLoadPost",
      callback = function()
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          local name = vim.api.nvim_buf_get_name(b)
          -- also drop the leftover directory buffer from `nvim .` (shows as a folder tab)
          if name:match("NvimTree_%d+$") or name:match("^diffview://") or (name ~= "" and vim.fn.isdirectory(name) == 1) then
            pcall(vim.api.nvim_buf_delete, b, { force = true })
          end
        end
      end,
    })
    -- evaluated now: nvim-tree hijacks the dir arg on startup and rewrites argv to NvimTree_N
    local argc = vim.fn.argc()
    local start_clean = argc == 0 or (argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1)
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if start_clean then
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
