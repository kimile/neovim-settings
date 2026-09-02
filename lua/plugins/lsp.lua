return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        -- Setup Mason first
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",        -- Lua
                "ts_ls",         -- TypeScript/JavaScript
                "sqlls",         -- SQL
                "prismals",      -- Prisma
            },
            automatic_installation = true,
        })

        -- Keymaps on LSP attach
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf }

                vim.keymap.set("n", "grd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>grs", function() require("telescope.builtin").lsp_workspace_symbols() end, opts)
                vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, opts)
                vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>grr", function() require("telescope.builtin").lsp_references() end, opts)
                vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
                vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
            end,
        })

        -- Setup language servers using new vim.lsp.config
        vim.lsp.config("lua_ls", {
            cmd = { "lua-language-server" },
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },
        })

        vim.lsp.config("ts_ls", {
            cmd = { "typescript-language-server", "--stdio" },
        })

        vim.lsp.config("sqlls", {
            cmd = { "sql-language-server", "up", "--method", "stdio" },
        })

        vim.lsp.config("prismals", {
            cmd = { "prisma-language-server", "--stdio" },
        })

        -- Enable servers
        vim.lsp.enable("lua_ls")
        vim.lsp.enable("ts_ls")
        vim.lsp.enable("sqlls")
        vim.lsp.enable("prismals")
    end,
}
