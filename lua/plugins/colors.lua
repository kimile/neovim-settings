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
        "echasnovski/mini.hipatterns",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local hipatterns = require("mini.hipatterns")
            hipatterns.setup({
                highlighters = {
                    hex_color = hipatterns.gen_highlighter.hex_color({ style = "inline", inline_text = "■ " }),
                    -- Swift: Color(red: 0xDF / 255, green: 0xFF / 255, blue: 0x00 / 255)
                    swift_color = {
                        pattern = "Color%(red:%s*0x%x%x%s*/%s*255,%s*green:%s*0x%x%x%s*/%s*255,%s*blue:%s*0x%x%x%s*/%s*255%)",
                        group = function(_, match)
                            local r, g, b = match:match("red:%s*0x(%x%x).-green:%s*0x(%x%x).-blue:%s*0x(%x%x)")
                            return hipatterns.compute_hex_color_group("#" .. r .. g .. b, "fg")
                        end,
                        -- square before the match, colored via fg of the group
                        extmark_opts = function(_, _, data)
                            return {
                                virt_text = { { "■ ", data.hl_group } },
                                virt_text_pos = "inline",
                                right_gravity = false,
                                priority = 200,
                            }
                        end,
                    },
                },
            })
        end,
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
