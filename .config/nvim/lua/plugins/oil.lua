return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			mode = "n",
			"-",
			"<cmd>Oil<CR>",
			desc = "Open the Oil file viewer",
		},
	},
	opts = {
		default_file_explorer = true,
	},
}
