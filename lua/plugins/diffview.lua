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
    opts = function()
        -- focus starts in the file panel; scrollbind only syncs once a diff pane is current
        local function focus_main()
            vim.schedule(function()
                local view = require("diffview.lib").get_current_view()
                local main = view and view.cur_layout and view.cur_layout:get_main_win()
                if main and vim.api.nvim_win_is_valid(main.id) then
                    vim.api.nvim_set_current_win(main.id)
                end
            end)
        end
        return {
            enhanced_diff_hl = true,
            view = {
                default = { layout = "diff2_horizontal" },
            },
            hooks = {
                -- fires on open and whenever a diff pane loads a file (file switch)
                diff_buf_win_enter = focus_main,
            },
        }
    end,
}
