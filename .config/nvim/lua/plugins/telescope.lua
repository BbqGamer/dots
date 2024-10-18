local builtin = require("telescope.builtin")

local M = {}

function M.cwd(opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local sorters = require("telescope.sorters")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local find_command = { "find", "/home/adam", "-maxdepth", "3", "-type", "d" }

	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "cd to directory",
			finder = finders.new_oneshot_job(find_command, {}),
			sorter = sorters.get_fuzzy_file({}),
			attach_mappings = function(prompt_bufnr, map)
				-- On Enter, set the cwd to the selected directory
				local function set_cwd()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					vim.cmd("cd " .. selection[1])
					print("Changed directory to: " .. selection[1])
				end

				-- Map <CR> (Enter) to the set_cwd function
				map("i", "<CR>", set_cwd)
				map("n", "<CR>", set_cwd)

				return true
			end,
		})
		:find()
end

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
			{ "<leader>pp", M.cwd },
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
