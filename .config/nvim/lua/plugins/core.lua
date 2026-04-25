return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		opts = {},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff" },
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
			},
		},
		keys = {
			{
				"<leader>ff",
				function()
					require("conform").format()
				end,
				desc = "Format buffer",
			},
		},
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({})
			vim.cmd.colorscheme("kanagawa")
		end,
	},
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
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
	},
	{
		"christoomey/vim-tmux-navigator",
		event = "VeryLazy",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			vim.schedule(function()
				local ok, configs = pcall(require, "nvim-treesitter.configs")
				if not ok then
					return
				end

				configs.setup({
					highlight = { enable = true },
					auto_install = true,
				})
			end)
		end,
	},
}
