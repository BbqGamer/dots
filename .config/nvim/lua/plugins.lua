return {
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
		"nordtheme/vim",
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
		"mbbill/undotree",
		keys = {
			{ "<leader>u", vim.cmd.UndotreeToggle },
		},
	},
	{ "folke/which-key.nvim", event = "VeryLazy" },
}
