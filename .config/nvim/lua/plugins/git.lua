return {
	{
		"tpope/vim-fugitive",
		cmd = {
			"G",
			"Git",
		},
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>lg", "<cmd>LazyGitCurrentFile<cr>" },
			{ "<leader>lc", "<cmd>LazyGitFilter<cr>" },
			{ "<leader>lf", "<cmd>LazyGitFilterCurrentFile<cr>" },
		},
	},
}
