return {
	"tpope/vim-commentary",
    "tpope/vim-fugitive",
    cmd = {
        "G",
        "Git",
    },
    {
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			latex = {
				enabled = true,
				converter = "latex2text",
				highlight = "RenderMarkdownMath",
				top_pad = 0,
				bottom_pad = 0,
			},
		},
	},
    {
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
    },
	"christoomey/vim-tmux-navigator",
    {
		"gbprod/nord.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nord").setup({})
			vim.cmd.colorscheme("nord")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged_enable = true,
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		},
	},
}
