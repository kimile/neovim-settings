return {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
        { "<leader>gv", "<cmd>DiffviewOpen<CR>",            desc = "Diffview: all changes" },
        { "<leader>gf", "<cmd>DiffviewFileHistory %<CR>",   desc = "Diffview: file history" },
        { "<leader>gF", "<cmd>DiffviewFileHistory<CR>",     desc = "Diffview: repo history" },
        { "<leader>gq", "<cmd>DiffviewClose<CR>",           desc = "Diffview: close" },
    },
    opts = {
        enhanced_diff_hl = true,
        hooks = {
            -- focus starts in the file panel; mouse-wheel scrollbind only works once a diff pane is current
            view_opened = function(view)
                vim.schedule(function()
                    local main = view.cur_layout and view.cur_layout:get_main_win()
                    if main and vim.api.nvim_win_is_valid(main.id) then
                        vim.api.nvim_set_current_win(main.id)
                    end
                end)
            end,
        },
        view = {
            default = { layout = "diff2_horizontal" },
        },
    },
}
