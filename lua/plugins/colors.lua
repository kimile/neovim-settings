return {
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({})
            vim.cmd.colorscheme "tokyonight"
        end
    },
    {
	"nvim-lualine/lualine.nvim",
	dependencies = {
	    "nvim-tree/nvim-web-devicons",
	},
	opts = {
	    theme = "tokyonight",
	}
    }
}
