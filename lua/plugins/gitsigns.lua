return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup({
            signs = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "▎" },
                topdelete    = { text = "▎" },
                changedelete = { text = "▎" },
            },
        })

        -- Hunk navigation (accessible on Portuguese layout via <leader> instead of bracket keys)
        vim.keymap.set("n", "<leader>hj", function() require("gitsigns").next_hunk() end, { desc = "Next git hunk" })
        vim.keymap.set("n", "<leader>hk", function() require("gitsigns").prev_hunk() end, { desc = "Prev git hunk" })

        -- Hunk actions
        vim.keymap.set("n", "<leader>hs", function() require("gitsigns").stage_hunk() end,       { desc = "Stage hunk" })
        vim.keymap.set("n", "<leader>hu", function() require("gitsigns").undo_stage_hunk() end,  { desc = "Undo stage hunk" })
        vim.keymap.set("n", "<leader>hr", function() require("gitsigns").reset_hunk() end,       { desc = "Reset hunk" })
        vim.keymap.set("n", "<leader>hp", function() require("gitsigns").preview_hunk() end,     { desc = "Preview hunk" })
        vim.keymap.set("n", "<leader>hb", function() require("gitsigns").toggle_current_line_blame() end, { desc = "Toggle line blame" })
    end,
}
