return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = true },
	},
	keys = function(_, keys)
		local builtin = require("telescope.builtin")

		-- Slightly advanced example of overriding default behavior and theme
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
					-- You can pass additional configuration to Telescope to change the theme, layout, etc.
					builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					}))
				end,
			},
			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			{
				"<leader>p/",
				function()
					builtin.live_grep({
						grep_open_files = true,
						prompt_title = "Live Grep in Open Files",
					})
				end,
			},
			-- Shortcut for searching your Neovim configuration files
			{
				"<leader>pn",
				function()
					builtin.find_files({ cwd = vim.fn.stdpath("config") })
				end,
			},
		}
	end,

	config = function()
		local telescope = require("telescope")
		telescope.setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		-- See `:help telescope.builtin`
	end,
}
