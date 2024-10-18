return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "nord",
		},
		sections = {
			lualine_c = {
				{
					"filename",
					file_status = true,
					path = 1,
				},
			},
			lualine_x = { "encoding", "filetype" },
		},
		inactive_sections = {
			lualine_c = {
				{
					"filename",
					file_status = true,
					path = 1,
				},
			},
		},
	},
}
