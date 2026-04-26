local function cwd_picker()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local sorters = require("telescope.sorters")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local find_command = { "find", os.getenv("HOME"), "-maxdepth", "3", "-type", "d" }

	pickers
		.new({}, {
			prompt_title = "cd to directory",
			finder = finders.new_oneshot_job(find_command, {}),
			sorter = sorters.get_fuzzy_file({}),
			attach_mappings = function(prompt_bufnr, map)
				local function set_cwd()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					vim.cmd("cd " .. vim.fn.fnameescape(selection[1]))
					print("Changed directory to: " .. selection[1])
				end

				map("i", "<CR>", set_cwd)
				map("n", "<CR>", set_cwd)

				return true
			end,
		})
		:find()
end

return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-tree/nvim-web-devicons", enabled = true },
		"nvim-telescope/telescope-ui-select.nvim",
		{ "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	opts = function()
		local actions = require("telescope.actions")
		local themes = require("telescope.themes")
		local lga_actions = require("telescope-live-grep-args.actions")

		return {
			defaults = {
				file_ignore_patterns = { "^.git" },
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					},
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				["ui-select"] = themes.get_dropdown({}),
				live_grep_args = {
					auto_quoting = false,
					mappings = {
						i = {
							["<C-k>"] = lga_actions.quote_prompt(),
							["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							["<C-h>"] = lga_actions.quote_prompt({ postfix = " --hidden " }),
							["<C-space>"] = lga_actions.to_fuzzy_refine,
						},
					},
				},
			},
		}
	end,
	config = function(_, opts)
		local telescope = require("telescope")

		telescope.setup(opts)
		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
		telescope.load_extension("live_grep_args")
	end,
	keys = {
		{
			"<leader>:",
			function()
				require("telescope.builtin").commands()
			end,
			desc = "Commands",
		},
		{
			"<leader>pm",
			function()
				require("telescope.builtin").man_pages({ sections = { "ALL" } })
			end,
			desc = "Man pages",
		},
		{ "<leader>pc", cwd_picker, desc = "Change working directory" },
		{
			"<leader>ph",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Help tags",
		},
		{
			"<leader>pk",
			function()
				require("telescope.builtin").keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>pf",
			function()
				require("telescope.builtin").find_files({ hidden = true })
			end,
			desc = "Find files",
		},
		{
			"<leader>pq",
			function()
				require("telescope.builtin").quickfix()
			end,
			desc = "Quickfix list",
		},
		{
			"<leader>ps",
			function()
				require("telescope.builtin").lsp_dynamic_workspace_symbols()
			end,
			desc = "Workspace symbols",
		},
		{
			"<leader>pt",
			function()
				require("telescope.builtin").builtin()
			end,
			desc = "Telescope pickers",
		},
		{
			"<leader>pw",
			function()
				require("telescope.builtin").grep_string()
			end,
			desc = "Grep word under cursor",
		},
		{
			"<leader>pg",
			function()
				require("telescope").extensions.live_grep_args.live_grep_args()
			end,
			desc = "Live grep with args",
		},
		{
			"<leader>pG",
			function()
				require("telescope.builtin").live_grep({ additional_args = { "--hidden" } })
			end,
			desc = "Live grep (hidden)",
		},
		{
			"<leader>pd",
			function()
				require("telescope.builtin").diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>pr",
			function()
				require("telescope.builtin").resume()
			end,
			desc = "Resume picker",
		},
		{
			"<leader>p.",
			function()
				require("telescope.builtin").oldfiles()
			end,
			desc = "Recent files",
		},
		{
			"<leader><leader>",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>/",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end,
			desc = "Search current buffer",
		},
		{
			"<leader>p/",
			function()
				require("telescope.builtin").live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end,
			desc = "Live grep open files",
		},
		{
			"<leader>pn",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config"), follow = true })
			end,
			desc = "Find Neovim config files",
		},
		{
			"<leader>pl",
			function()
				require("telescope.builtin").find_files({ cwd = os.getenv("HOME") .. "/life" })
			end,
			desc = "Find life files",
		},
	},
}
