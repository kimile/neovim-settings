return {
    {
        "navarasu/onedark.nvim",
        config = function()
            require("onedark").setup({
                style = "deep" -- Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
            })
            vim.cmd.colorscheme "onedark"
        end
    },
    {
	"nvim-lualine/lualine.nvim",
	dependencies = {
	    "nvim-tree/nvim-web-devicons",
	},
	opts = {
	    theme = "onedark",
	}
    }
}
