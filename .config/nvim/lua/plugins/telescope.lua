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
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>pc", builtin.commands)
		vim.keymap.set("n", "<leader>pm", function()
			builtin.man_pages({ sections = { "ALL" } })
		end)
		vim.keymap.set("n", "<leader>ph", builtin.help_tags)
		vim.keymap.set("n", "<leader>pk", builtin.keymaps)
		vim.keymap.set("n", "<leader>pf", function()
			builtin.find_files({ hidden = true })
		end)
		vim.keymap.set("n", "<leader>ps", builtin.builtin)
		vim.keymap.set("n", "<leader>pw", builtin.grep_string)
		vim.keymap.set("n", "<leader>pg", function()
			builtin.live_grep({
				additional_args = { "--hidden" },
			})
		end)
		vim.keymap.set("n", "<leader>pd", builtin.diagnostics)
		vim.keymap.set("n", "<leader>pr", builtin.resume)
		vim.keymap.set("n", "<leader>p.", builtin.oldfiles)
		vim.keymap.set("n", "<leader><leader>", builtin.buffers)

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end)

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>p/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end)

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>pn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end)
	end,
}
