return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "UIEnter",
    config = function()
        -- onedark "deep" palette subset used for explicit highlights
        local deep = {
            bg_bar   = "#141b24",
            bg_inact = "#1a212e",
            bg_sel   = "#21283b",
            bg_sep   = "#0c0e15",
            fg_inact = "#455574",
            fg_sel   = "#93a4c3",
            blue     = "#41a7fc",
            red      = "#f65866",
            yellow   = "#efbd5d",
            green    = "#8bcd5b",
        }

        local function close_buf(bufnr)
            for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
                local alt
                for _, b in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
                    if b.bufnr ~= bufnr and vim.bo[b.bufnr].filetype ~= "NvimTree" then
                        alt = b.bufnr
                        break
                    end
                end
                vim.api.nvim_win_call(win, function()
                    if alt then vim.api.nvim_win_set_buf(win, alt) else vim.cmd("enew") end
                end)
            end
            pcall(vim.cmd, "bdelete! " .. bufnr)
        end

        require("bufferline").setup({
            options = {
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level)
                    local icons = { error = " ", warning = " ", info = " ", hint = "󰌶 " }
                    return (icons[level] or "") .. count
                end,
                numbers = "none",
                separator_style = "slope",
                always_show_bufferline = true,
                show_buffer_close_icons = true,
                show_close_icon = false,
                show_buffer_icons = true,
                -- Offset so the tab bar clears nvim-tree (width must match tree.lua view.width = 30)
                offsets = {
                    {
                        filetype   = "NvimTree",
                        text       = "File Explorer",
                        text_align = "center",
                        separator  = true,
                        highlight  = "Directory",
                    },
                },
                hover = { enabled = true, delay = 150, reveal = { "close" } },
                -- Plain `bdelete` can close the editor window, leaving NvimTree full-screen.
                -- Swap windows to another buffer first so the layout (and offset) survives.
                close_command = close_buf,
                right_mouse_command = close_buf,
                middle_mouse_command = close_buf,
            },
            highlights = {
                fill                 = { bg = deep.bg_bar },
                background           = { fg = deep.fg_inact, bg = deep.bg_inact },
                buffer_visible       = { fg = deep.fg_inact, bg = deep.bg_inact },
                buffer_selected      = { fg = deep.fg_sel,   bg = deep.bg_sel, bold = true, italic = false },
                separator            = { fg = deep.bg_sep,   bg = deep.bg_inact },
                separator_selected   = { fg = deep.bg_sep,   bg = deep.bg_sel },
                separator_visible    = { fg = deep.bg_sep,   bg = deep.bg_inact },
                indicator_selected   = { fg = deep.blue,     bg = deep.bg_sel },
                modified             = { fg = deep.yellow,   bg = deep.bg_inact },
                modified_selected    = { fg = deep.yellow,   bg = deep.bg_sel },
                close_button         = { fg = deep.fg_inact, bg = deep.bg_inact },
                close_button_selected = { fg = deep.red,    bg = deep.bg_sel },
                error                = { fg = deep.red,     bg = deep.bg_inact },
                error_selected       = { fg = deep.red,     bg = deep.bg_sel, bold = true },
                warning              = { fg = deep.yellow,  bg = deep.bg_inact },
                warning_selected     = { fg = deep.yellow,  bg = deep.bg_sel, bold = true },
                info                 = { fg = deep.green,   bg = deep.bg_inact },
                info_selected        = { fg = deep.green,   bg = deep.bg_sel, bold = true },
                hint                 = { fg = deep.green,   bg = deep.bg_inact },
                hint_selected        = { fg = deep.green,   bg = deep.bg_sel, bold = true },
                tab                  = { fg = deep.fg_inact, bg = deep.bg_inact },
                tab_selected         = { fg = deep.fg_sel,   bg = deep.bg_sel },
                tab_separator        = { fg = deep.bg_sep,   bg = deep.bg_inact },
                tab_separator_selected = { fg = deep.bg_sep, bg = deep.bg_sel },
                tab_close            = { fg = deep.red,      bg = deep.bg_bar },
                pick                 = { fg = deep.red,      bg = deep.bg_inact, bold = true },
                pick_selected        = { fg = deep.red,      bg = deep.bg_sel,   bold = true },
            },
        })

        -- <S-h>/<S-l> override vim's built-in H/L (screen top/bottom) — common trade-off
        vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Buffer: prev" })
        vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Buffer: next" })

        -- <leader>b namespace — completely free in this config
        vim.keymap.set("n", "<leader>bx", "<cmd>bdelete<CR>",                       { desc = "Buffer: close" })
        vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>",          { desc = "Buffer: close others" })
        vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>",            { desc = "Buffer: pin/unpin" })
        vim.keymap.set("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Buffer: close unpinned" })
        vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<CR>",            { desc = "Buffer: close all left" })
        vim.keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>",           { desc = "Buffer: close all right" })
    end,
}
