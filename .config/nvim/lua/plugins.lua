return {
	"tpope/vim-fugitive",
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
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	"tpope/vim-commentary",
	"christoomey/vim-tmux-navigator",
	{
		"jpalardy/vim-slime",
		init = function()
			vim.g.slime_target = "tmux"
			vim.g.slime_python_ipython = 1
		end,
	},
	{
		"arcticicestudio/nord-vim",
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("nord")
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {},
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			vim.keymap.set("n", "<leader>e", vim.cmd.NvimTreeToggle)
			require("nvim-tree").setup({})
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("oil").setup({})
			vim.keymap.set("n", "-", "<CMD>Oil<CR>")
		end,
	},
	{
		"mbbill/undotree",
		init = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				yaml = { "yamlfmt" },
				json = { "jq" },
				tex = { "latexindent" },
			},
		},
	},
	-- Autocompletion
	"tpope/vim-dadbod",
	"kristijanhusak/vim-dadbod-ui",
	"kristijanhusak/vim-dadbod-completion",
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
