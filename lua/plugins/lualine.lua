return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup({
            options = {
                theme = 'auto',
            },
            sections = {
                lualine_b = {
                    {
                        function()
                            return vim.g.project_name or vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
                        end,
                        icon = '󰉖',
                    },
                    'branch',
                },
                lualine_c = {
                    {
                        'filename',
                        path = 1,  -- 0 = just filename, 1 = relative path, 2 = absolute path
                    }
                }
            }
        })
    end,
}
