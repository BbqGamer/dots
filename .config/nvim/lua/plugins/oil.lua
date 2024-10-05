return {
	"stevearc/oil.nvim",
	lazy = false,
	---@module 'oil'
	---@type oil.SetupOpts
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
		columns = {
			"icon",
			"permissions",
			"size",
			"mtime",
		},
		delete_to_trash = false,
		skip_confirm_for_simple_edits = true,
	},
}
