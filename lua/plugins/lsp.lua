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

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>grs", function() require("telescope.builtin").lsp_workspace_symbols() end, opts)
                vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, opts)
                vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>grr", function() require("telescope.builtin").lsp_references() end, opts)
                -- tRPC fallback: text search for client calls of the procedure under cursor
                vim.keymap.set("n", "<leader>grt", function()
                    local word = vim.fn.expand("<cword>")
                    local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or vim.fn.getcwd()
                    require("telescope.builtin").grep_string({
                        cwd = root,
                        use_regex = true,
                        search = "\\." .. word .. "\\.(query|mutate|useQuery|useMutation|useSuspenseQuery|useInfiniteQuery|useSuspenseInfiniteQuery|subscribe|useSubscription|queryOptions|mutationOptions)",
                    })
                end, opts)
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
            -- One tsserver for the whole monorepo so references cross packages (tRPC client <-> router)
            root_dir = function(bufnr, on_dir)
                local root = vim.fs.root(bufnr, {
                    "pnpm-workspace.yaml", "turbo.json", "lerna.json", "nx.json", ".git",
                })
                    or vim.fs.root(bufnr, { "tsconfig.json", "package.json" })
                if root then on_dir(root) end
            end,
            init_options = {
                preferences = {
                    disableSourceOfProjectReferenceRedirect = true,
                },
                tsserver = { maxTsServerMemory = 8192 },
            },
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
