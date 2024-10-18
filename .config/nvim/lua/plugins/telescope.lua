return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-tree/nvim-web-devicons", enabled = true },
	},
	keys = function(_, keys)
		return {
			{ "<leader>pc", builtin.commands },
			{
				"<leader>pm",
				function()
					builtin.man_pages({ sections = { "ALL" } })
				end,
			},
			{ "<leader>ph", builtin.help_tags },
			{ "<leader>pk", builtin.keymaps },
			{
				"<leader>pf",
				function()
					builtin.find_files({ hidden = true })
				end,
			},
			{ "<leader>ps", builtin.builtin },
			{ "<leader>pw", builtin.grep_string },
			{
				"<leader>pg",
				function()
					builtin.live_grep({
						additional_args = { "--hidden" },
					})
				end,
			},
			{ "<leader>pd", builtin.diagnostics },
			{ "<leader>pr", builtin.resume },
			{ "<leader>p.", builtin.oldfiles },
			{ "<leader><leader>", builtin.buffers },
			{
				"<leader>/",
				function()
					builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					}))
				end,
			},
			{
				"<leader>p/",
				function()
					builtin.live_grep({
						grep_open_files = true,
						prompt_title = "Live Grep in Open Files",
					})
				end,
			},
			{
				"<leader>pn",
				function()
					builtin.find_files({ cwd = vim.fn.stdpath("config") })
				end,
			},
		}
	end,
}
